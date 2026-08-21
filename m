Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954633DD522
	for <nvdimm@lists.linux.dev>; Fri, 21 Aug 2026 19:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787341182; cv=pass; b=TL4fQsQnTjDGptT5jeW665jr66p0ZPcNzrm0p38Z7IIpNPnkAPyyWDYgXKICkSvMdl33Zmjck0Rsd8oSThqam5t8QTjkP1aRXkzRasnJHQmHZ7fwJy+JFISrQ7ucfsgXqf3ftCsorvUP0wDnbteljdzgTb10rG3MNhOV0wXmFdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787341182; c=relaxed/simple;
	bh=2QaAsriM6IS3lTgDPUOF48nwqc8aTC29sa5P2y66CZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZcGISLI7zti0A4VRUFkCA+NoEqTnMmJNpz4WmbwGDrg9gVyFcBdr7DYl+D8KhkLh38ERpkm8ilSvccasKlKTIIrtG0pWhb9h+MmZ0qUTxwPeYGF0piE22St1Z172m9MHZhbCDtPGkKC6oj7Z7p4z+Ue7k5uLT8JtJteRh1WvFjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=mQeL9GCo; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="mQeL9GCo"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8ee43b3e5abso9074606d6.3
        for <nvdimm@lists.linux.dev>; Fri, 21 Aug 2026 12:39:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787341178; cv=none;
        d=google.com; s=arc-20260327;
        b=hgYGlbbiaWC073qdcpnVDjwJI1G4/g79GjypJJWQ3esG/Z5+MqS6XZ2Xyh843OP+Rz
         +dauaKWRAym43pWp3nwWbORiqxKKd2qpZqwBk9emROSb4FhkBMGkroem0wz3hCM/7TyB
         hhxs2t7+nB4UqHvTq7AzUSyK0okoD78VZqTwRTUCgF9/zHqbvGIrN03ss7vbrRRU1DAz
         /xq+zDGvJNEkS10G25bJ2tSc9CF0mh7WpqlXngVIhCH/JZaOPX0i4jfEeQjmkFDj2rTo
         bqi+FgJPEljrGu2xUeVylNaCeQqP6nk+h336g/UjcfPbRNq5ALJhgv69vwqSKIrFIRcE
         rLyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KUV4QsUdOhj/C4gedxjcRezZM90WK5l233fM+QINPEo=;
        fh=XMPy9mE5Cx7fgCMhKuTKWZcVd78vSlTSb11N4ClxiFE=;
        b=domEfAVL6UpfNbcusuLHEKHxoOjlL/eL2PgrCWpf3Z7qgDh5c0VFRrSy9jaS27eXiQ
         1HS7UrKg9Y9lLug06Dcjgzp9jtBpEHg2kKoIz/eK/cFumxyjbud3M35vOV9R/9FkcFYc
         3ZItkLQH9Cj7OJ9y2yocjnK6hwr7s5+hSjXqLGA7HGSSTMmrYxgePx/4haxA9Ut29O9t
         RYKLMVBLmyV/bM+XGz080OPKOSpJfhnvRZ5QJlnHWwMnEgaXKKhgeMnn2VD//7ulddjB
         2I4REcqYMd4nOavv1Za19eoTE3PePzJZTjuFoe5R77Np8bVw9DhGCt0QAMgh7Zd75mu3
         sl0g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787341178; x=1787945978; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KUV4QsUdOhj/C4gedxjcRezZM90WK5l233fM+QINPEo=;
        b=mQeL9GCoFxkza2lAYix+dA594MljsVKaN/TPELf1NkbVPKSKL4xGW+UkkXmwhcCdDV
         +gLQmmtteCQv7nVbiFF9wsAu0FUSqPXftOkV93ugrTeYW+O+aE4GOtJkpFacY+N/T9dK
         hW+NPr9mnZAGl6qXfrMYYGxVp2qIzIptsM1yg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787341178; x=1787945978;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KUV4QsUdOhj/C4gedxjcRezZM90WK5l233fM+QINPEo=;
        b=cH6pbtVCnCEPvcSIclmjSn855cskSrDe8KRor9wNoPrChLg3zQh5b2M1Nv+Eo73ujC
         lDrGySKigKHd/mE8TxMo/L2rRxEp4/vJ7THyHbS7ps22m8lI0NhJ2G3JkgNCT8CFRjAp
         5awhlbVoSFiWxQg4u2vM33r4MmLOZDAHrZCt2TzQWEJ9rzwpc3wbab0ahn5c9B0jbTDx
         YaRA35F2B4tOFun8gsmdJ3KcThan7jmjUF+eGZAhLA92ZOK8JsQjIjQjhPrZMV9G1/sv
         +IS6LQg3GD/XuNdw89Oci6QJVnCsQYnpGxcWcSaOs+dsHrDC78bMz8BCS4MO+eThipC8
         1oNA==
X-Forwarded-Encrypted: i=1; AHgh+Rpk06InJaaEGYmYglCKM2SeW09LAyfqwk+AQAArkpo2iL6/Uhe93WBFvml95idkrflXMLwum+U=@lists.linux.dev
X-Gm-Message-State: AFuF++l9vDhi8Edzu8tuDOK2vR2XrWVLLya26tBUZQhgbwT55KpF6mXz
	YtF1XZbaO9LmbXnmjnLja/IdR5UGa2eq9uw+9bYa0dwz9ZNviYn2pLIDfIMY/c+J7JWzhJ/tJlG
	ii83aGjTs+k62VU007R3eAOVfcCzE0ZsBUEA0dr8AXA==
X-Gm-Gg: AR+sD10rxJHh0SM5j0bmxCWcE18720imsfSuN7jCfcXeoCyib9cUZm+qoRJd6FdDSbg
	4yGUXrmkjG8SpbsjtqfhAfhoEPPNDggszfalXTBvquvUDeUiGbxrCHRIp9HbRXRcCcaY37vpRJr
	Cxj+X8V6N+lJUajHgLB5ekZZ8NfH2CIRfYxvNHUWcxLx00/1HrJV7A24GncWSyHw3ZA5prb67Z8
	uxCQnKrEE7mABk8OKWQMvyk98T/8Y7KCH5byZYeN9u0VAdb1ZQIvzsWVldC8rNGozoIvh93258K
	83oInX5aGxMXKS0VjGOtMxMrYr1hlskWozbEVrWWnudgEkVccjQGCc2t7jQMR1h44Y4Q50vp/bl
	VJYtvLT3vQV0dhGeVjdsRNPXvahWGf/fD
X-Received: by 2002:a05:622a:1f8a:b0:51c:1532:ae93 with SMTP id
 d75a77b69052e-52df5a32867mr88198341cf.26.1787341177980; Fri, 21 Aug 2026
 12:39:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com> <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs> <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner> <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
In-Reply-To: <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Aug 2026 21:39:26 +0200
X-Gm-Features: AcwNN1V5lCcm6_l8LY5VakD6tTocDvE06I1hYgFmfavubxTv285rgBmrPN7M8XY
Message-ID: <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	John Groves <john@jagalactic.com>, John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <jic23@kernel.org>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham <gabewhigham@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Aug 2026 at 13:40, David Hildenbrand (Arm) <david@kernel.org> wrote:

> (a) Whether a fuse-based approach is feasible.
>
>     Are there any major blockers remaining?

No.

> (b) Whether a fuse-based approach is inefficient.
>
>     Are there scenarios remaining where performance or metadata overhead would
>     be bad without an easy way to improve the situation?

Lookups can be cached, extent mappings can also be cached.   After the
inode is in cache and the mapping is set up zero requests are needed
for open/mmap/read/write/close.

> (c) Whether a fuse-based approach is a bad conceptual fit.
>
>     Will fuse have to carry a lot of famfs special sauce that cannot
>     really be used elsewhere / generalized?

None.

But "can" and "will" are not the same.  The striping code might not be
very useful outside of famfs.

> (d) Whether a fuse-based approach is too invasive.
>
>     Will fuse extensions to support famfs actually make it harder to maintain or
>     slower on some paths?

No.

> (e) Whether a fuse-based approach will make famfs harder to extend.
>
>     Is there known follow-up work that will be hard/impossible to model in fuse?

It would actually make famfs much easier to extend, since the
directory structure, metadata, etc. is now controllable within the
userspace server.

> (f) Whether a fuse-based approach will reduce maintenance effor
>
>     Will maintaining fuse extensions possibly be harder than maintaining
>     standalone famfs?

Testing is a key point.  Famfs needs special hardware or emulation, so
it's not straightforward to test.  This could be solved by adding a
"dummy" mode to famfs server that exercises the same fuse API, but
instead of special hardware would just use plain memory.

> (g) Whether a fuse-based approach would make famfs more complex.
>
>     Will the shift to user space result in a significantly more complicated
>     overall solution that must be maintained?

The server would be somewhat more complex, since it's now implementing
things like pathname lookup, etc.  But the other stuff (managing file
maps) should be very similar.

> (h) Who would help drive the fuse approach?
>
>     Fuse people seem to be willing to help, but I expect that there must be a
>     close cooperation with John to make this fly. I don't expect that John
>     himself can easily (or understandably wants to :) ) do the heavy fuse
>     lifting.

Yes, this is where previous efforts seem to have gone off the rails.
So I agree to take responsibility for implementing the kernel side and
help with the server side on the condition that John has trust in
this.   I'm not promising -7.4, but can at least try.

Without John's trust I'm not taking this on.

> (i) Who would maintain any famfs fuse extensions and own any bugs?
>
>     famfs will possibly depend on fuse extensions that might initially only be
>     used by famfs. Would the fuse maintainers just naturally deal with that?

I can take responsibility for the fuse kernel bits.

> (j) Whether a fuse-based approach has an end in sight.
>
>     famfs goes back .... quite a long time. It would be nice to close that
>     chapter :)
>
>     Is there an end in sight, or could we end up in the same situation in 6m/1y/
>     ...
>
>     IOW, is there a way to agree on an MVP that won't require a lot of further
>     re-planning and changes to a fuse-based design?

I already sent patches to implement the dax dev mapping, and the
striping.  We've discussed adding support for fixed backing ID, which
was something that John asked for.  The only missing piece was adding
a protocol extension to set up  simple extent mappings, which already
existed in the famfs_fuse patch, just needed to be renamed and unused
fields changed to "spare".

We (Amir, Joanne, me) explained to John how this is exactly what's
needed to make famfs work.  We've not seen an acceptance of that yet.

From my PoV this would be extra work, but in the longer term would
expect to be less overall maintenance work and fuse would gain some
useful features in the process.

Thanks,
Miklos
