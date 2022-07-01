Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C291855;
	Fri,  1 Jul 2022 10:10:39 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id o16-20020a05600c379000b003a02eaea815so3814821wmr.0;
        Fri, 01 Jul 2022 03:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u/VrgVPkgzQyMENrkjqrTLDR84XHdXIPxg7GPzE6OD8=;
        b=C/MmEOGhSRIfH+EXKc+5tPWL/j3KmXe2C9yF4G29xk8dw1gd61VTKWCyxtLAZxh4sb
         UE5/kL75GepM+uRycCWRLMpXDY85nUuyxC666CDf9pf73xgkHk37OmHMb05dNiVx0XRD
         Y2RQ3aefb1GLjqJCg6cZQpZGxI4W7dJG0I4Xu6isQM8oYWN5zHlwT3bNDD+2+f/IN2bz
         KEATzw78NNRNFuRMWf74dJWFfG1Alqj2WHdrZc3jvO2Hl91xEwPvZ3kICxcp5Cfi/xuH
         4yHXD3gEhuMOCMB1ZHwCCLoRlSGDfeUmOl6kSlr2C0uRsfmgqcQT84oSp03pN2e/Ng4L
         4JWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/VrgVPkgzQyMENrkjqrTLDR84XHdXIPxg7GPzE6OD8=;
        b=3e3Zt1+vIZZiIN14BB/ZLSoK4lBJS986wYu+XIvYcm84zWVfopYvTSI18kUbIz6jjC
         mqGQHKKfDqUUWUhHRGGnJ1LVR9fGpmDEajobOu00vERLUx9R/PyznUwAT2Zy8bRr3SgT
         xvyBWHjN8Wyslygo7yOQWALQpTrVaZghhBwkiBKlKsKMs9yBkUx80Kqulur0c6ot8odY
         Ad1y5ZgyP1D7/8vbVZLCnoHPxbt09rR02VvOCt9Sezddvm9FT6tRknlskkTvYzBRhLlN
         CwImccyCB4bl53tNAOGAJCG3LI8hTZEJ2KThOEX5PkkSGHhSEZr/aDP12d4syouLQ9uG
         xhQA==
X-Gm-Message-State: AJIora+1o5RqxO8sJ/vP983M929rJKlvNQkJysCN4xvqA71U5XJTFBie
	RHuIMvwwcQvwMPUrqYH+uNg=
X-Google-Smtp-Source: AGRyM1stCxr1gM7DIYC9Nmu+TnueYLM+JhpsNdef1mUcnSairJRZL+vZe4MHLjaYJlH6VyT7URSq+Q==
X-Received: by 2002:a05:600c:b51:b0:3a1:71b0:a115 with SMTP id k17-20020a05600c0b5100b003a171b0a115mr13622469wmr.41.1656670237475;
        Fri, 01 Jul 2022 03:10:37 -0700 (PDT)
Received: from opensuse.localnet (host-79-53-109-127.retail.telecomitalia.it. [79.53.109.127])
        by smtp.gmail.com with ESMTPSA id m12-20020adfe0cc000000b0021d4155cd6fsm3257748wri.53.2022.07.01.03.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 03:10:36 -0700 (PDT)
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Ira Weiny <ira.weiny@intel.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev, io-uring@vger.kernel.org, linux-riscv@lists.infradead.org, llvm@lists.linux.dev
Subject: Re: [PATCH] fs: Replace kmap{,_atomic}() with kmap_local_page()
Date: Fri, 01 Jul 2022 12:10:33 +0200
Message-ID: <3187836.aeNJFYEL58@opensuse>
In-Reply-To: <8735fmqcfz.fsf@email.froward.int.ebiederm.org>
References: <20220630163527.9776-1-fmdefrancesco@gmail.com> <8735fmqcfz.fsf@email.froward.int.ebiederm.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On gioved=C3=AC 30 giugno 2022 19:38:08 CEST Eric W. Biederman wrote:
> "Fabio M. De Francesco" <fmdefrancesco@gmail.com> writes:
>=20
> > The use of kmap() and kmap_atomic() are being deprecated in favor of
> > kmap_local_page().
> >
> > With kmap_local_page(), the mappings are per thread, CPU local and not
> > globally visible. Furthermore, the mappings can be acquired from any
> > context (including interrupts).
> >
> > Therefore, use kmap_local_page() in exec.c because these mappings are=20
per
> > thread, CPU local, and not globally visible.
> >
> > Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
> > HIGHMEM64GB enabled.
>=20
> Can someone please refresh my memory on what is going on.
>=20
> I remember there were limitations that kmap_atomic had that are hard to
> meet so something I think it was kmap_local was invented and created
> to be the kmap_atomic replacement.

Please read highmem.rst. I've updated that document weeks ago:
https://docs.kernel.org/vm/highmem.html?highlight=3Dhighmem

Currently it contains many more information I can ever place here in order=
=20
to answer your questions.

Believe me, this is not by any means a way to elude your questions. I'm=20
pretty sure that by reading that document you'll have a clear vision on=20
what is going on :-)

>=20
> What are the requirements on kmap_local?  In copy_strings
> kmap is called in contexts that can sleep in page faults

No problems with kmap_local_page() with regard to page faults (again,=20
please read the above-mentioned document).

=46rom that document...

"It=E2=80=99s valid to take pagefaults in a local kmap region []".

"Each call of kmap_atomic() in the kernel creates a non-preemptible section=
=20
and disable pagefaults. This could be a source of unwanted latency.=20
Therefore users should prefer kmap_local_page() instead of kmap_atomic().".

> so any
> nearly any requirement except a thread local use is invalidated.
>=20
> As you have described kmap_local above it does not sound like kmap_local
> is safe in this context,

Sorry, probably I should add that taking page faults is allowed. Would you=
=20
prefer I send a v2 and add this information?

Thanks,

=46abio

> but that could just be a problem in description
> that my poor memory does is not recalling the necessary details to
> correct.
>=20
> Eric
>=20
> > Suggested-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> > ---
> >  fs/exec.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 0989fb8472a1..4a2129c0d422 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -583,11 +583,11 @@ static int copy_strings(int argc, struct=20
user_arg_ptr argv,
> > =20
> >  				if (kmapped_page) {
> >  				=09
flush_dcache_page(kmapped_page);
> > -					kunmap(kmapped_page);
> > +					kunmap_local(kaddr);
> >  				=09
put_arg_page(kmapped_page);
> >  				}
> >  				kmapped_page =3D page;
> > -				kaddr =3D kmap(kmapped_page);
> > +				kaddr =3D=20
kmap_local_page(kmapped_page);
> >  				kpos =3D pos & PAGE_MASK;
> >  				flush_arg_page(bprm, kpos,=20
kmapped_page);
> >  			}
> > @@ -601,7 +601,7 @@ static int copy_strings(int argc, struct=20
user_arg_ptr argv,
> >  out:
> >  	if (kmapped_page) {
> >  		flush_dcache_page(kmapped_page);
> > -		kunmap(kmapped_page);
> > +		kunmap_local(kaddr);
> >  		put_arg_page(kmapped_page);
> >  	}
> >  	return ret;
> > @@ -883,11 +883,11 @@ int transfer_args_to_stack(struct linux_binprm=20
*bprm,
> > =20
> >  	for (index =3D MAX_ARG_PAGES - 1; index >=3D stop; index--) {
> >  		unsigned int offset =3D index =3D=3D stop ? bprm->p &=20
~PAGE_MASK : 0;
> > -		char *src =3D kmap(bprm->page[index]) + offset;
> > +		char *src =3D kmap_local_page(bprm->page[index]) +=20
offset;
> >  		sp -=3D PAGE_SIZE - offset;
> >  		if (copy_to_user((void *) sp, src, PAGE_SIZE - offset)=20
!=3D 0)
> >  			ret =3D -EFAULT;
> > -		kunmap(bprm->page[index]);
> > +		kunmap_local(src);
> >  		if (ret)
> >  			goto out;
> >  	}
> > @@ -1680,13 +1680,13 @@ int remove_arg_zero(struct linux_binprm *bprm)
> >  			ret =3D -EFAULT;
> >  			goto out;
> >  		}
> > -		kaddr =3D kmap_atomic(page);
> > +		kaddr =3D kmap_local_page(page);
> > =20
> >  		for (; offset < PAGE_SIZE && kaddr[offset];
> >  				offset++, bprm->p++)
> >  			;
> > =20
> > -		kunmap_atomic(kaddr);
> > +		kunmap_local(kaddr);
> >  		put_arg_page(page);
> >  	} while (offset =3D=3D PAGE_SIZE);
>=20




