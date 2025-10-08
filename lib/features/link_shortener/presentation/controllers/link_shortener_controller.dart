import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:url_shortener/core/result/either_extensions.dart';
import 'package:url_shortener/core/services/link_opener.dart';
import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';
import 'package:url_shortener/features/link_shortener/domain/usecases/shorten_url.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/url_to_shorten.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_state.dart';

@injectable
class LinkShortenerController extends Cubit<LinkShortenerState> {
  LinkShortenerController(
    this._shortenUrl,
     this._linkOpener) : super(const LinkShortenerIdle());

  final ShortenUrl _shortenUrl;
  final UrlLauncherLinkOpener _linkOpener;

  Future<void> shorten(String url) async {
    if (url.trim().isEmpty) return;

    if (_checkDuplicateAndPromote(url)) return;

    emit(LinkShortenerLoading(items: state.items));

    final urlToShortenParse = UrlToShorten.tryParse(url);

    final (failure, urlToShorten) = urlToShortenParse.unpack();

    if (failure != null) {
      emit(LinkShortenerError(items: state.items, errorCode: failure.code));
      return;
    }

    final response = await _shortenUrl(urlToShorten!);

    final (failureRequest, result) = response.unpack();

    if (failureRequest != null) {
      emit(
        LinkShortenerError(items: state.items, errorCode: failureRequest.code),
      );
      return;
    }

    final updated = [result!, ...state.items];

    emit(LinkShortenerSuccess(items: updated));
  }

  Future<void> open(ShortLink link) async {
    var opened = await _linkOpener.open(link.short);
    if (!opened) {
      opened = await _linkOpener.open(link.original);
    }
    if (!opened) {
      emit(
        LinkShortenerError(items: state.items, errorCode: 'errorOpenUrlFailed'),
      );
    }
  }

  bool _checkDuplicateAndPromote(String rawURL) {
    final index = state.items.indexWhere(
      (link) => link.original.toString().trim() == rawURL.trim(),
    );

    if (index >= 0) {
      final updatedList = List<ShortLink>.from(state.items);

      final link = updatedList.removeAt(index);

      updatedList.insert(0, link);

      emit(LinkShortenerSuccess(items: updatedList));

      return true;
    }

    return false;
  }

  void deleteLink(ShortLink link) {
    final updatedItems = List<ShortLink>.from(state.items)..remove(link);
    emit(LinkShortenerSuccess(items: updatedItems));
  }

  void clearError() {
    if (state is LinkShortenerError) {
      emit(LinkShortenerSuccess(items: state.items));
    }
  }
}
