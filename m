Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4207E;
	Sat, 23 Jul 2022 01:02:37 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id w12so7539144edd.13;
        Fri, 22 Jul 2022 18:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jlyu+Ezdns1o/Dl+mNDx1dSSzCArmmCHe5zOulHCgYY=;
        b=PZsBl5ooCfsAyfBssviyiVR5Tq1jj7pKvSq+8EIYiuLRuANId3eEJ8Cfne0oRH5tST
         cNckwvwkYNCJil7c4bHdQwdq+1j/ZICMbKPDmupGpGkjuYuypwIlqr25b/2zb8nGj+L7
         8X6BT7i0cfdvLYah+oB/+uw18/v7O2tlssjrHraunx39DcQd6oIsFM91LN1KRUjOeySk
         107g886IDOhDMfSuVZ8M22SN2x2lCSM95MlNgPfYmjNiwur+gHG+g9710+/nPbgwn0jJ
         VB2nk9BZ+suPliZX/YIqKiK3alTptYuhcFjUg7RbgvcF8nWJZFV9um7H8k3hL7Y+Q5TY
         PsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jlyu+Ezdns1o/Dl+mNDx1dSSzCArmmCHe5zOulHCgYY=;
        b=lkdKDV5u2uzyx6fRC/Zh5JGLGpIbHrLXh0Bx9RLQ1kUZ/1LbIbp5vRLo3J+UFlMrEa
         +pMR0yrhIoRpdb8DMH1TLvKfSmiPArKmfpkvu8WhYhjSgwYn+fz+ifW3WAvp5aciEqxo
         roxngfGzd7vt9vxAiA2fbckitLU58KtpxM1C0q4h7DTY85d+5Ip84jeUnHweUfWVy2eF
         rzL+vvE78t83Z8ij/ENokmTns5jaMpN+650hwMNxbNnANwKt9omxEn7ojGKRHg4ZfQDi
         xCIwS01mjzQd41wa8DfcZ4Fv/nTaswWKY+QdPn/TOWTnmzhqmoIBs1MQGWrrxMP/BaDQ
         BQpw==
X-Gm-Message-State: AJIora8ETTNNo8WEZ1aGL5QZ4JrJRiF1z++XnS7GcCTkvJGcfpI1zHTY
	FwpABPBYdXCGAUu0RuBDM8s=
X-Google-Smtp-Source: AGRyM1sAMP8KHkAWh5bS378ppL8TdO4StC0sEC6TB/Rq2m5BGNgizfRRhPByQs8fPv0/46kAMhGelA==
X-Received: by 2002:a05:6402:524d:b0:43a:72fe:76b7 with SMTP id t13-20020a056402524d00b0043a72fe76b7mr2211131edd.398.1658538155443;
        Fri, 22 Jul 2022 18:02:35 -0700 (PDT)
Received: from opensuse.localnet (host-79-56-6-250.retail.telecomitalia.it. [79.56.6.250])
        by smtp.gmail.com with ESMTPSA id r10-20020a1709061baa00b0071cef8bafc3sm2549153ejg.1.2022.07.22.18.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 18:02:34 -0700 (PDT)
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev, io-uring@vger.kernel.org, linux-riscv@lists.infradead.org, llvm@lists.linux.dev
Subject: Re: [PATCH] fs: Call kmap_local_page() in copy_string_kernel()
Date: Sat, 23 Jul 2022 03:02:32 +0200
Message-ID: <2115146.irdbgypaU6@opensuse>
In-Reply-To: <Ytnr3IhSkDOjqbZ1@iweiny-desk3>
References: <20220710100136.25496-1-fmdefrancesco@gmail.com> <Ytnr3IhSkDOjqbZ1@iweiny-desk3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On venerd=C3=AC 22 luglio 2022 02:14:20 CEST Ira Weiny wrote:
> On Sun, Jul 10, 2022 at 12:01:36PM +0200, Fabio M. De Francesco wrote:
> > The use of kmap_atomic() is being deprecated in favor of=20
kmap_local_page().
> >=20
> > With kmap_local_page(), the mappings are per thread, CPU local, not
> > globally visible and can take page faults. Furthermore, the mappings=20
can be
> > acquired from any context (including interrupts).
> >=20
> > Therefore, use kmap_local_page() in copy_string_kernel() instead of
> > kmap_atomic().
> >=20
> > Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
> > HIGHMEM64GB enabled.
> >=20
> > Suggested-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> > ---
> >=20
> > I sent a first patch to fs/exec.c for converting kmap() and=20
kmap_atomic()
> > to kmap_local_page():
> > https://lore.kernel.org/lkml/20220630163527.9776-1-fmdefrancesco@gmail.=
com/
> >=20
> > Some days ago, Ira Weiny, while he was reviewing that patch, made me=20
notice
> > that I had overlooked a second kmap_atomic() in the same file (thanks):
> > https://lore.kernel.org/lkml/YsiQptk19txHrG4c@iweiny-desk3/
> >=20
> > I've been asked to send this as an additional change. This is why there=
=20
will
> > not be any second version of that previous patch.
> >=20
> >  fs/exec.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 4a2129c0d422..5fa652ca5823 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -639,11 +639,11 @@ int copy_string_kernel(const char *arg, struct=20
linux_binprm *bprm)
> >  		page =3D get_arg_page(bprm, pos, 1);
> >  		if (!page)
> >  			return -E2BIG;
> > -		kaddr =3D kmap_atomic(page);
> > +		kaddr =3D kmap_local_page(page);
> >  		flush_arg_page(bprm, pos & PAGE_MASK, page);
>=20
> I really question why we can't use memcpy_to_page() here and move the
> flush_arg_page() prior to the mapping?
>=20
> flush_arg_page() only calls flush_cache_page() which does not need the
> mapping to work correctly AFAICT.

You're right here. I'm sorry for being so lazy and not checking that=20
flush_arg_page() does not need to be called while the task holds the local=
=20
mapping :-(

In v2 I'll move flush_arg_page() one line above memcpy_to_page().

Thanks for your comment,

=46abio

>=20
> Ira
>=20
> >  		memcpy(kaddr + offset_in_page(pos), arg,=20
bytes_to_copy);
> >  		flush_dcache_page(page);
> > -		kunmap_atomic(kaddr);
> > +		kunmap_local(kaddr);
> >  		put_arg_page(page);
> >  	}
> > =20
> > --=20
> > 2.36.1
> >=20
>=20




