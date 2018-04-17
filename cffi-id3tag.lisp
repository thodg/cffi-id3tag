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

(define-foreign-library libid3tag
  (:unix (:or "libid3tag.so.0" "libid3tag.so"))
  (t (:default "libid3tag")))

(use-foreign-library libid3tag)

(defcfun ("id3_file_open" c-id3-file-open) :pointer
  (name :string)
  (mode id3-file-mode))

(defun id3-file-open (name &optional (mode +id3-file-mode-readonly+))
  (c-id3-file-open name mode))

(defcfun ("id3_file_fdopen" c-id3-file-fdopen) :pointer
  (fd :int)
  (mode id3-file-mode))

(defun id3-file-fdopen (fd &optional (mode +id3-file-mode-readonly+))
  (c-id3-file-fdopen fd mode))

(defcfun ("id3_file_close" c-id3-file-close) :int
  (file :pointer))

(defun id3-file-close (file)
  (c-id3-file-close file))

(defcfun ("id3_file_tag" c-id3-file-tag) (:pointer (:struct id3-tag))
  (file :pointer))

(defun id3-file-tag (file)
  (c-id3-file-tag file))

(defcfun ("id3_file_update" c-id3-file-update) :int
  (file :pointer))

(defun id3-file-update (file)
  (c-id3-file-update file))

(defcfun ("id3_tag_new" c-id3-tag-new) (:pointer (:struct id3-tag)))

(defun id3-tag-new ()
  (c-id3-tag-new))

(defcfun ("id3_tag_delete" c-id3-tag-delete) :void
  (tag (:pointer (:struct id3-tag))))

(defun id3-tag-delete (tag)
  (c-id3-tag-delete tag))

(defcfun ("id3_tag_version" c-id3-tag-version) :unsigned-int
  (tag (:pointer (:struct id3-tag))))

(defun id3-tag-version (tag)
  (c-id3-tag-version tag))

(defcfun ("id3_tag_options" c-id3-tag-options) :int
  (tag (:pointer (:struct id3-tag)))
  (a :int)
  (b :int))

(defun id3-tag-options (tag a b)
  (c-id3-tag-options tag a b))

(defcfun ("id3_tag_setlength" c-id3-tag-setlength) :void
  (tag (:pointer (:struct id3-tag)))
  (length id3-length-t))

(defun id3-tag-setlength (tag length)
  (c-id3-tag-setlength tag length))

(defcfun ("id3_tag_clearframes" c-id3-tag-clearframes) :void
  (tag (:pointer (:struct id3-tag))))

(defun id3-tag-clearframes (tag)
  (c-id3-tag-clearframes tag))

(defcfun ("id3_tag_attachframe" c-id3-tag-attachframe) :int
  (tag (:pointer (:struct id3-tag)))
  (frame (:pointer (:struct id3-frame))))

(defun id3-tag-attachframe (tag frame)
  (c-id3-tag-attachframe tag frame))

(defcfun ("id3_tag_detachframe" c-id3-tag-detachframe) :int
  (tag (:pointer (:struct id3-tag)))
  (frame (:pointer (:struct id3-frame))))

(defun id3-tag-detachframe (tag frame)
  (c-id3-tag-detachframe tag frame))

(defcfun ("id3_tag_findframe" c-id3-tag-findframe)
    (:pointer (:struct id3-frame))
  (tag (:pointer (:struct id3-tag)))
  (str :string)
  (n :unsigned-int))

(defun id3-tag-findframe (tag str n)
  (c-id3-tag-findframe tag str n))

(defcfun ("id3_tag_query" c-id3-tag-query) :long
  (query (:pointer id3-byte-t))
  (length id3-length-t))

(defun id3-tag-query (query length)
  (c-id3-tag-query query length))

(defcfun ("id3_tag_parse" c-id3-tag-parse) (:pointer (:struct id3-tag))
  (data (:pointer id3-byte-t))
  (length id3-length-t))

(defun id3-tag-parse (bytes)
  (c-id3-tag-parse bytes (length bytes)))

(defcfun ("id3_tag_render" c-id3-tag-render) id3-length-t
  (tag (:pointer (:struct id3-tag)))
  (data (:pointer id3-byte-t)))

(defun id3-tag-render (tag)
  (with-foreign-object (buf 'id3-byte-t 1024)
    (let ((len (c-id3-tag-render tag buf)))
      (let ((out (make-array `(,len) :element-type 'id3-byte-t)))
        (dotimes (i len)
          (setf (aref out i) (mem-aref buf 'id3-byte-t i)))
        out))))

(defcfun ("id3_frame_new" c-id3-frame-new)
    (:pointer (:struct id3-frame))
  (str :string))

(defun id3-frame-new (str)
  (c-id3-frame-new str))

(defcfun ("id3_frame_delete" c-id3-frame-delete) :void
  (frame (:pointer (:struct id3-frame))))

(defun id3-frame-delete (frame)
  (c-id3-frame-delete frame))

(defcfun ("id3_frame_field" c-id3-frame-field) id3-field-type
  (frame (:pointer (:struct id3-frame)))
  (n :unsigned-int))

(defun id3-frame-field (frame n)
  (c-id3-frame-field frame n))

(defcfun ("id3_field_type" c-id3-field-type) id3-field-type
  (field (:pointer (:union id3-field))))

(defun id3-field-type (field)
  (c-id3-field-type field))

(defcfun ("id3_field_setint" c-id3-field-setint) :int
  (field (:pointer (:union id3-field)))
  (value :long))

(defun id3-field-setint (field value)
  (c-id3-field-setint field value))

(defcfun ("id3_field_settextencoding" c-id3-field-settextencoding) :int
  (field (:pointer (:union id3-field)))
  (value id3-field-textencoding))

(defun id3-field-settextencoding (field value)
  (c-id3-field-settextencoding field value))

(defcfun ("id3_field_setstrings" c-id3-field-setstrings) :int
  (field (:pointer (:union id3-field)))
  (nstrings :unsigned-int)
  (strings (:pointer (:pointer id3-ucs4-t))))

(defun id3-field-setstrings (field &rest strings)
  (c-id3-field-setstrings field (length strings) strings))

(defcfun ("id3_field_addstring" c-id3-field-addstring) :int
  (field (:pointer (:union id3-field)))
  (str (:pointer id3-ucs4-t)))

(defun id3-field-addstring (field str)
  (c-id3-field-addstring field str))

(defcfun ("id3_field_setlanguage" c-id3-field-setlanguage) :int
  (field (:pointer (:union id3-field)))
  (value :string))

(defun id3-field-setlanguage (field value)
  (c-id3-field-setlanguage field value))

(defcfun ("id3_field_setlatin1" c-id3-field-setlatin1) :int
  (field (:pointer (:union id3-field)))
  (value (:pointer id3-latin1-t)))

(defun id3-field-setlatin1 (field value)
  (c-id3-field-setlatin1 field value))

(defcfun ("id3_field_setfulllatin1" c-id3-field-setfulllatin1) :int
  (field (:pointer (:union id3-field)))
  (value (:pointer id3-latin1-t)))

(defun id3-field-setfulllatin1 (field value)
  (c-id3-field-setfulllatin1 field value))

(defcfun ("id3_field_setstring" c-id3-field-setstring) :int
  (field (:pointer (:union id3-field)))
  (value (:pointer id3-ucs4-t)))

(defun id3-field-setstring (field value)
  (c-id3-field-setstring field value))

(defcfun ("id3_field_setfullstring" c-id3-field-setfullstring) :int
  (field (:pointer (:union id3-field)))
  (value (:pointer id3-ucs4-t)))

(defun id3-field-setfullstring (field value)
  (c-id3-field-setfullstring field value))

(defcfun ("id3_field_setframeid" c-id3-field-setframeid) :int
  (field (:pointer (:union id3-field)))
  (value :string))

(defun id3-field-setframeid (field value)
  (c-id3-field-setframeid field value))

(defcfun ("id3_field_setbinarydata" c-id3-field-setbinarydata) :int
  (field (:pointer (:union id3-field)))
  (value (:pointer id3-byte-t))
  (length id3-length-t))

(defun id3-field-setbinarydata (field seq)
  (c-id3-field-setbinarydata field seq (length seq)))

(defcfun ("id3_field_getint" c-id3-field-getint) :long
  (field (:pointer (:union id3-field))))

(defun id3-field-getint (field)
  (c-id3-field-getint field))

(defcfun ("id3_field_gettextencoding" c-id3-field-gettextencoding)
    id3-field-textencoding
  (field (:pointer (:union id3-field))))

(defun id3-field-gettextencoding (field)
  (c-id3-field-gettextencoding field))

(defcfun ("id3_field_getlatin1" c-id3-field-getlatin1)
    (:pointer id3-latin1-t)
  (field (:pointer (:union id3-field))))

(defun id3-field-getlatin1 (field)
  (c-id3-field-getlatin1 field))

(defcfun ("id3_field_getfulllatin1" c-id3-field-getfulllatin1)
    (:pointer id3-latin1-t)
  (field (:pointer (:union id3-field))))

(defun id3-field-getfulllatin1 (field)
  (c-id3-field-getfulllatin1 field))

(defcfun ("id3_field_getstring" c-id3-field-getstring)
    (:pointer id3-ucs4-t)
  (field (:pointer (:union id3-field))))

(defun id3-field-getstring (field)
  (c-id3-field-getstring field))

(defcfun ("id3_field_getfullstring" c-id3-field-getfullstring)
    (:pointer id3-ucs4-t)
  (field (:pointer (:union id3-field))))

(defun id3-field-getfullstring (field)
  (c-id3-field-getfullstring field))

(defcfun ("id3_field_getnstrings" c-id3-field-getnstrings) :unsigned-int
  (field (:pointer (:union id3-field))))

(defun id3-field-getnstrings (field)
  (c-id3-field-getnstrings field))

(defcfun ("id3_field_getstrings" c-id3-field-getstrings)
    (:pointer id3-ucs4-t)
  (field (:pointer (:union id3-field)))
  (n :unsigned-int))

(defun id3-field-getstrings (field n)
  (c-id3-field-getstrings field n))

(defcfun ("id3_field_getframeid" c-id3-field-getframeid) :string
  (field (:pointer (:union id3-field))))

(defun id3-field-getframeid (field)
  (c-id3-field-getframeid field))

(defcfun ("id3_field_getbinarydata" c-id3-field-getbinarydata)
    (:pointer id3-byte-t)
  (field (:pointer (:union id3-field)))
  (length id3-length-t))

(defun id3-field-getbinarydata (field length)
  (c-id3-field-getbinarydata field length))

(defcfun ("id3_genre_index" c-id3-genre-index) (:pointer id3-ucs4-t)
  (index :unsigned-int))

(defun id3-genre-index (index)
  (c-id3-genre-index index))

(defcfun ("id3_genre_name" c-id3-genre-name) (:pointer id3-ucs4-t)
  (genre (:pointer id3-ucs4-t)))

(defun id3-genre-name (genre)
  (c-id3-genre-name genre))

(defcfun ("id3_genre_number" c-id3-genre-number) :int
  (genre (:pointer id3-ucs4-t)))

(defun id3-genre-number (genre)
  (c-id3-genre-number genre))

(defcfun ("id3_ucs4_latin1duplicate" c-id3-ucs4-latin1duplicate)
    (:pointer id3-latin1-t)
  (ucs4 (:pointer id3-ucs4-t)))

(defun id3-ucs4-latin1duplicate (ucs4)
  (c-id3-ucs4-latin1duplicate ucs4))

(defcfun ("id3_ucs4_utf16duplicate" c-id3-ucs4-utf16duplicate)
    (:pointer id3-utf16-t)
  (ucs4 (:pointer id3-ucs4-t)))

(defun id3-ucs4-utf16duplicate (ucs4)
  (c-id3-ucs4-utf16duplicate ucs4))

(defcfun ("id3_ucs4_utf8duplicate" c-id3-ucs4-utf8duplicate)
    (:pointer id3-utf8-t)
  (ucs4 (:pointer id3-ucs4-t)))

(defun id3-ucs4-utf8duplicate (ucs4)
  (c-id3-ucs4-utf8duplicate ucs4))

(defcfun ("id3_ucs4_putnumber" c-id3-ucs4-putnumber) :void
  (ucs4 (:pointer id3-ucs4-t))
  (number :unsigned-long))

(defun id3-ucs4-putnumber (ucs4 number)
  (c-id3-ucs4-putnumber ucs4 number))

(defcfun ("id3_ucs4_getnumber" c-id3-ucs4-getnumber) :unsigned-long
  (ucs4 (:pointer id3-ucs4-t)))

(defun id3-ucs4-getnumber (ucs4)
  (c-id3-ucs4-getnumber ucs4))

(defcfun ("id3_latin1_ucs4duplicate" c-id3-latin1-ucs4duplicate)
    (:pointer id3-ucs4-t)
  (latin1 (:pointer id3-latin1-t)))

(defun id3-latin1-ucs4duplicate (latin1)
  (c-id3-latin1-ucs4duplicate latin1))

(defcfun ("id3_utf16_ucs4duplicate" c-id3-utf16-ucs4duplicate)
    (:pointer id3-ucs4-t)
  (utf16 (:pointer id3-utf16-t)))

(defun id3-utf16-ucs4duplicate (utf16)
  (c-id3-utf16-ucs4duplicate utf16))

(defcfun ("id3_utf8_ucs4duplicate" c-id3-utf8-ucs4duplicate)
    (:pointer id3-ucs4-t)
  (utf8 (:pointer id3-utf8-t)))

(defun id3-utf8-ucs4duplicate (utf8)
  (c-id3-utf8-ucs4duplicate utf8))
