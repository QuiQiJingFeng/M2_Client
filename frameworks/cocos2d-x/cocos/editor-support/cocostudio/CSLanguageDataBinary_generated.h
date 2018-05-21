// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_CSLANGUAGEDATABINARY_FLATBUFFERS_H_
#define FLATBUFFERS_GENERATED_CSLANGUAGEDATABINARY_FLATBUFFERS_H_

#include "flatbuffers/flatbuffers.h"

namespace flatbuffers {

struct LanguageItem;

struct LanguageSet;

struct LanguageItem FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_KEY = 4,
    VT_VALUE = 6
  };
  const flatbuffers::String *key() const { return GetPointer<const flatbuffers::String *>(VT_KEY); }
  const flatbuffers::String *value() const { return GetPointer<const flatbuffers::String *>(VT_VALUE); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_KEY) &&
           verifier.Verify(key()) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_VALUE) &&
           verifier.Verify(value()) &&
           verifier.EndTable();
  }
};

struct LanguageItemBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_key(flatbuffers::Offset<flatbuffers::String> key) { fbb_.AddOffset(LanguageItem::VT_KEY, key); }
  void add_value(flatbuffers::Offset<flatbuffers::String> value) { fbb_.AddOffset(LanguageItem::VT_VALUE, value); }
  LanguageItemBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  LanguageItemBuilder &operator=(const LanguageItemBuilder &);
  flatbuffers::Offset<LanguageItem> Finish() {
    auto o = flatbuffers::Offset<LanguageItem>(fbb_.EndTable(start_, 2));
    return o;
  }
};

inline flatbuffers::Offset<LanguageItem> CreateLanguageItem(flatbuffers::FlatBufferBuilder &_fbb,
    flatbuffers::Offset<flatbuffers::String> key = 0,
    flatbuffers::Offset<flatbuffers::String> value = 0) {
  LanguageItemBuilder builder_(_fbb);
  builder_.add_value(value);
  builder_.add_key(key);
  return builder_.Finish();
}

inline flatbuffers::Offset<LanguageItem> CreateLanguageItemDirect(flatbuffers::FlatBufferBuilder &_fbb,
    const char *key = nullptr,
    const char *value = nullptr) {
  return CreateLanguageItem(_fbb, key ? _fbb.CreateString(key) : 0, value ? _fbb.CreateString(value) : 0);
}

struct LanguageSet FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_LANGUAGEITEMS = 4
  };
  const flatbuffers::Vector<flatbuffers::Offset<LanguageItem>> *languageItems() const { return GetPointer<const flatbuffers::Vector<flatbuffers::Offset<LanguageItem>> *>(VT_LANGUAGEITEMS); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_LANGUAGEITEMS) &&
           verifier.Verify(languageItems()) &&
           verifier.VerifyVectorOfTables(languageItems()) &&
           verifier.EndTable();
  }
};

struct LanguageSetBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_languageItems(flatbuffers::Offset<flatbuffers::Vector<flatbuffers::Offset<LanguageItem>>> languageItems) { fbb_.AddOffset(LanguageSet::VT_LANGUAGEITEMS, languageItems); }
  LanguageSetBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  LanguageSetBuilder &operator=(const LanguageSetBuilder &);
  flatbuffers::Offset<LanguageSet> Finish() {
    auto o = flatbuffers::Offset<LanguageSet>(fbb_.EndTable(start_, 1));
    return o;
  }
};

inline flatbuffers::Offset<LanguageSet> CreateLanguageSet(flatbuffers::FlatBufferBuilder &_fbb,
    flatbuffers::Offset<flatbuffers::Vector<flatbuffers::Offset<LanguageItem>>> languageItems = 0) {
  LanguageSetBuilder builder_(_fbb);
  builder_.add_languageItems(languageItems);
  return builder_.Finish();
}

inline flatbuffers::Offset<LanguageSet> CreateLanguageSetDirect(flatbuffers::FlatBufferBuilder &_fbb,
    const std::vector<flatbuffers::Offset<LanguageItem>> *languageItems = nullptr) {
  return CreateLanguageSet(_fbb, languageItems ? _fbb.CreateVector<flatbuffers::Offset<LanguageItem>>(*languageItems) : 0);
}

inline const flatbuffers::LanguageSet *GetLanguageSet(const void *buf) {
  return flatbuffers::GetRoot<flatbuffers::LanguageSet>(buf);
}

inline bool VerifyLanguageSetBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<flatbuffers::LanguageSet>(nullptr);
}

inline void FinishLanguageSetBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<flatbuffers::LanguageSet> root) {
  fbb.Finish(root);
}

}  // namespace flatbuffers

#endif  // FLATBUFFERS_GENERATED_CSLANGUAGEDATABINARY_FLATBUFFERS_H_
