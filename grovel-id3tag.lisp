;;
;;  cffi-id3tag  -  Common Lisp wrapper for libid3tag
;;
;;  Copyright 2018 Thomas de Grivel <thoxdg@gmail.com>
;;
;;  Permission to use, copy, modify, and distribute this software for any
;;  purpose with or without fee is hereby granted, provided that the above
;;  copyright notice and this permission notice appear in all copies.
;;
;;  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;;  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;;  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;;  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;;  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;;  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;;  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;;

(in-package :cffi-id3tag)

(include "id3tag.h")

(constant (+id3-tag-version+ "ID3_TAG_VERSION"))

(ctype id3-byte-t "id3_byte_t")
(ctype id3-length-t "id3_length_t")

(ctype id3-ucs4-t "id3_ucs4_t")

(ctype id3-latin1-t "id3_latin1_t")
(ctype id3-utf16-t "id3_utf16_t")
(ctype id3-utf8-t "id3_utf8_t")

(cstruct id3-tag "struct id3_tag"
         (refcount "refcount" :type :unsigned-int)
         (version "version" :type :unsigned-int)
         (flags "flags" :type :int)
         (extendedflags "extendedflags" :type :int)
         (restrictions "restrictions" :type :int)
         (options "options" :type :int)
         (nframes "nframes" :type :unsigned-int)
         (frames "frames" :type :pointer)
         (paddedsize "paddedsize" :type id3-length-t))

(constant (+id3-tag-querysize+ "ID3_TAG_QUERYSIZE"))

(constant (+id3-frame-title+ "ID3_FRAME_TITLE") :type symbol)
(constant (+id3-frame-artist+ "ID3_FRAME_ARTIST") :type symbol)
(constant (+id3-frame-album+ "ID3_FRAME_ALBUM") :type symbol)
(constant (+id3-frame-track+ "ID3_FRAME_TRACK") :type symbol)
(constant (+id3-frame-year+ "ID3_FRAME_YEAR") :type symbol)
(constant (+id3-frame-genre+ "ID3_FRAME_GENRE") :type symbol)
(constant (+id3-frame-comment+ "ID3_FRAME_COMMENT") :type symbol)
(constant (+id3-frame-obsolete+ "ID3_FRAME_OBSOLETE") :type symbol)

(cenum id3-tag-flag
       ((:unsynchronisation "ID3_TAG_FLAG_UNSYNCHRONISATION"))
       ((:extendedheader "ID3_TAG_FLAG_EXTENDEDHEADER"))
       ((:experimentalindicator "ID3_TAG_FLAG_EXPERIMENTALINDICATOR"))
       ((:footerpresent "ID3_TAG_FLAG_FOOTERPRESENT"))
       ((:knownflags "ID3_TAG_FLAG_KNOWNFLAGS")))

(cenum id3-tag-extendedflag
       ((:tagisanupdate "ID3_TAG_EXTENDEDFLAG_TAGISANUPDATE"))
       ((:crcdatapresent "ID3_TAG_EXTENDEDFLAG_CRCDATAPRESENT"))
       ((:tagrestrictions "ID3_TAG_EXTENDEDFLAG_TAGRESTRICTIONS"))
       ((:knownflags "ID3_TAG_EXTENDEDFLAG_KNOWNFLAGS")))

(cenum id3-tag-restriction-tagsize
       ((:mask "ID3_TAG_RESTRICTION_TAGSIZE_MASK"))
       ((:128-frames-1-mb "ID3_TAG_RESTRICTION_TAGSIZE_128_FRAMES_1_MB"))
       ((:64-frames-128-kb
        "ID3_TAG_RESTRICTION_TAGSIZE_64_FRAMES_128_KB"))
       ((:32-frames-40-kb "ID3_TAG_RESTRICTION_TAGSIZE_32_FRAMES_40_KB"))
       ((:32-frames-4-kb "ID3_TAG_RESTRICTION_TAGSIZE_32_FRAMES_4_KB")))

(cenum id3-tag-restriction-textencoding
       ((:mask "ID3_TAG_RESTRICTION_TEXTENCODING_MASK"))
       ((:none "ID3_TAG_RESTRICTION_TEXTENCODING_NONE"))
       ((:latin1-utf8 "ID3_TAG_RESTRICTION_TEXTENCODING_LATIN1_UTF8")))

(cenum id3-tag-restriction-textsize
       ((:mask "ID3_TAG_RESTRICTION_TEXTSIZE_MASK"))
       ((:none "ID3_TAG_RESTRICTION_TEXTSIZE_NONE"))
       ((:1024-chars "ID3_TAG_RESTRICTION_TEXTSIZE_1024_CHARS"))
       ((:128-chars "ID3_TAG_RESTRICTION_TEXTSIZE_128_CHARS"))
       ((:30-chars "ID3_TAG_RESTRICTION_TEXTSIZE_30_CHARS")))

(cenum id3-tag-restriction-imageencoding
       ((:mask "ID3_TAG_RESTRICTION_IMAGEENCODING_MASK"))
       ((:none "ID3_TAG_RESTRICTION_IMAGEENCODING_NONE"))
       ((:png-jpeg "ID3_TAG_RESTRICTION_IMAGEENCODING_PNG_JPEG")))

(cenum id3-tag-restriction-imagesize
       ((:mask "ID3_TAG_RESTRICTION_IMAGESIZE_MASK"))
       ((:none "ID3_TAG_RESTRICTION_IMAGESIZE_NONE"))
       ((:256-256 "ID3_TAG_RESTRICTION_IMAGESIZE_256_256"))
       ((:64-64 "ID3_TAG_RESTRICTION_IMAGESIZE_64_64"))
       ((:64-64-exact "ID3_TAG_RESTRICTION_IMAGESIZE_64_64_EXACT")))

(cenum id3-tag-option
       ((:unsynchronisation "ID3_TAG_OPTION_UNSYNCHRONISATION"))
       ((:compression "ID3_TAG_OPTION_COMPRESSION"))
       ((:crc "ID3_TAG_OPTION_CRC"))
       ((:appendedtag "ID3_TAG_OPTION_APPENDEDTAG"))
       ((:filealtered "ID3_TAG_OPTION_FILEALTERED"))
       ((:id3v1 "ID3_TAG_OPTION_ID3V1")))

(cstruct id3-frame "struct id3_frame"
         (id "id" :type :char :count 5)
         (description "description" :type :string)
         (refcount "refcount" :type :unsigned-int)
         (flags "flags" :type :int)
         (group-id "group_id" :type :int)
         (encryption-method "encryption_method" :type :int)
         (encoded "encoded" :type (:pointer id3-byte-t))
         (encoded-length "encoded_length" :type id3-length-t)
         (decoded-length "decoded_length" :type id3-length-t)
         (nfields "nfields" :type :unsigned-int)
         (fields "fields" :type :pointer))

(cenum id3-frame-flag
       ((:tagalterpreservation "ID3_FRAME_FLAG_TAGALTERPRESERVATION"))
       ((:filealterpreservation "ID3_FRAME_FLAG_FILEALTERPRESERVATION"))
       ((:readonly "ID3_FRAME_FLAG_READONLY"))
       ((:statusflags "ID3_FRAME_FLAG_STATUSFLAGS"))
       ((:groupingidentity "ID3_FRAME_FLAG_GROUPINGIDENTITY"))
       ((:compression "ID3_FRAME_FLAG_COMPRESSION"))
       ((:encryption "ID3_FRAME_FLAG_ENCRYPTION"))
       ((:unsynchronisation "ID3_FRAME_FLAG_UNSYNCHRONISATION"))
       ((:datalengthindicator "ID3_FRAME_FLAG_DATALENGTHINDICATOR"))
       ((:formatflags "ID3_FRAME_FLAG_FORMATFLAGS"))
       ((:knownflags "ID3_FRAME_FLAG_KNOWNFLAGS")))

(ctype id3-field-type "enum id3_field_type")
(cenum id3-field-type
       ((:textencoding "ID3_FIELD_TYPE_TEXTENCODING"))
       ((:latin1 "ID3_FIELD_TYPE_LATIN1"))
       ((:latin1full "ID3_FIELD_TYPE_LATIN1FULL"))
       ((:latin1list "ID3_FIELD_TYPE_LATIN1LIST"))
       ((:string "ID3_FIELD_TYPE_STRING"))
       ((:stringfull "ID3_FIELD_TYPE_STRINGFULL"))
       ((:stringlist "ID3_FIELD_TYPE_STRINGLIST"))
       ((:language "ID3_FIELD_TYPE_LANGUAGE"))
       ((:frameid "ID3_FIELD_TYPE_FRAMEID"))
       ((:date "ID3_FIELD_TYPE_DATE"))
       ((:int8 "ID3_FIELD_TYPE_INT8"))
       ((:int16 "ID3_FIELD_TYPE_INT16"))
       ((:int24 "ID3_FIELD_TYPE_INT24"))
       ((:int32 "ID3_FIELD_TYPE_INT32"))
       ((:int32plus "ID3_FIELD_TYPE_INT32PLUS"))
       ((:binarydata "ID3_FIELD_TYPE_BINARYDATA")))

(ctype id3-field-textencoding "enum id3_field_textencoding")
(cenum id3-field-textencoding
       ((:iso-8859-1 "ID3_FIELD_TEXTENCODING_ISO_8859_1"))
       ((:utf-16 "ID3_FIELD_TEXTENCODING_UTF_16"))
       ((:utf-16be "ID3_FIELD_TEXTENCODING_UTF_16BE"))
       ((:utf-8 "ID3_FIELD_TEXTENCODING_UTF_8")))

(cstruct id3-field-number "struct { enum id3_field_type type; signed long value; }"
         (type "type" :type id3-field-type)
         (value "value" :type :long))

(cstruct id3-field-latin1 "struct { enum id3_field_type type; id3_latin1_t *ptr; }"
         (type "type" :type id3-field-type)
         (ptr "ptr" :type (:pointer id3-latin1-t)))

(cstruct id3-field-latin1list "struct { enum id3_field_type type; unsigned int nstrings; id3_latin1_t **strings; }"
         (type "type" :type id3-field-type)
         (nstrings "nstrings" :type :unsigned-int)
         (strings "strings" :type (:pointer (:pointer id3-latin1-t))))

(cstruct id3-field-string "struct { enum id3_field_type type; id3_ucs4_t *ptr; }"
         (type "type" :type id3-field-type)
         (ptr "ptr" :type (:pointer id3-ucs4-t)))

(cstruct id3-field-stringlist "struct { enum id3_field_type type; unsigned int nstrings; id3_ucs4_t **strings; }"
         (type "type" :type id3-field-type)
         (nstrings "nstrings" :type :unsigned-int)
         (strings "strings" :type (:pointer (:pointer id3-ucs4-t))))

(cstruct id3-field-immediate "struct { enum id3_field_type type; char value[9]; }"
         (type "type" :type id3-field-type)
         (value "value" :type :char :count 9))

(cstruct id3-field-binary "struct { enum id3_field_type type; id3_byte_t *data; id3_length_t length; }"
         (type "type" :type id3-field-type)
         (data "data" :type (:pointer id3-byte-t))
         (length "length" :type id3-length-t))

(cunion id3-field "union id3_field"
        (type "type" :type id3-field-type)
        (number "number" :type (:struct id3-field-number))
        (latin1 "latin1" :type (:struct id3-field-latin1))
        (latin1list "latin1list" :type (:struct id3-field-latin1list))
        (string "string" :type (:struct id3-field-string))
        (stringlist "stringlist" :type (:struct id3-field-stringlist))
        (immediate "immediate" :type (:struct id3-field-immediate))
        (binary "binary" :type (:struct id3-field-binary)))

(ctype id3-file-mode "enum id3_file_mode")
(cenum id3-file-mode
       ((:readonly "ID3_FILE_MODE_READONLY"))
       ((:readwrite "ID3_FILE_MODE_READWRITE")))

(constant (+id3-version-major+ "ID3_VERSION_MAJOR"))
(constant (+id3-version-minor+ "ID3_VERSION_MINOR"))
(constant (+id3-version-patch+ "ID3_VERSION_PATCH"))
(constant (+id3-version-extra+ "ID3_VERSION_EXTRA") :type string)

(constant (+id3-version+ "ID3_VERSION") :type string)

(constant (+id3-publishyear+ "ID3_PUBLISHYEAR") :type string)
(constant (+id3-author+ "ID3_AUTHOR") :type string)
(constant (+id3-email+ "ID3_EMAIL") :type string)

(cvar ("id3_version" id3-version) :string)
(cvar ("id3_copyright" id3-copyright) :string)
(cvar ("id3_author" id3-author) :string)
(cvar ("id3_build" id3-build) :string)
