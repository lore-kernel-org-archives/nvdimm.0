Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905AF7B;
	Sat,  9 Jul 2022 18:30:34 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id h17so2256852wrx.0;
        Sat, 09 Jul 2022 11:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UzXTEzvirVIfQgpRsZ+S3IQH5KHrdqAU7esxyuqlcI4=;
        b=azFPTNNmWWMPgUFKlPXqmgq48Ky1+NFueWA8CeF4u6bOZNNqI/ZouXYtrZzIQI8369
         tHNRrJbP3Sk+Qceww9e7NnrcuDgJ6oXsFN+7UXhcMdUokeJ6YJlHAlJxMvos2ldKLn3j
         7qnyIMJNcvc4n+99h6ZoUqIl96IBxZcSLUP2Row3p9htPHtQDjaOVGMxEPZIg0ThAzku
         JP/YMWoEj/7gz/zYLt8XR5fUmxUTGzc7A4L/NsKoD1clU44nb9/glj7xUMteE9ztqdCY
         xScs/VQryAk4+7BFaPGN8I56D8qyIDvJpCmOtxLQds1DYNF1pzvoTJw1JwfwK48t37Iw
         OhgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UzXTEzvirVIfQgpRsZ+S3IQH5KHrdqAU7esxyuqlcI4=;
        b=NIBU2WCX2O79dMoUrWBs0zM5wZT416HAEH0AtaulvIQpJ80khufgLbcJxVo8jTqYob
         O722iDRKI8o9rUY+EWMstKpEw9mDW4eou8m7wBkMIFzLvnFHnsdkiYF3ZH85fZauj4Ym
         bqKOzF9k/vwQSfp91bIQbKZ9Z8EMOFGG6PYHUYNEw3e8mKFtLKglnyCj8V0LxxKreyGV
         uFkYFLzQGbn1mKHajRRrFuOxkSO/jEBM+uU1Hco6JcCNPQIDJcRjJrFR+dwwU38xyJdW
         dLlA9MnsaEuVYlm5LSj0/pS7Cj1fCHyAuZkpzqPGhxPURrNf/B3cA3NbTT6aFA1auX0Z
         Khxg==
X-Gm-Message-State: AJIora8KZZ2i+SVqMtjIpdSvd2rBk7vOkju4e573PAJ6ftpO+QY9gjIO
	Jmx3VKFcoVJePonod+MuO98=
X-Google-Smtp-Source: AGRyM1tAtrtLBOTNfS7tOy8h/BBFOAIT9pR7nVNc89ZMI3mrlIbdzOc1A9K2XpDn13ZLjn4N3vi0ng==
X-Received: by 2002:adf:e0c9:0:b0:21b:8271:2348 with SMTP id m9-20020adfe0c9000000b0021b82712348mr8620979wri.222.1657391432677;
        Sat, 09 Jul 2022 11:30:32 -0700 (PDT)
Received: from opensuse.localnet (host-95-235-102-55.retail.telecomitalia.it. [95.235.102.55])
        by smtp.gmail.com with ESMTPSA id j9-20020a05600c190900b0039db31f6372sm6358721wmq.2.2022.07.09.11.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jul 2022 11:30:31 -0700 (PDT)
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev, io-uring@vger.kernel.org, linux-riscv@lists.infradead.org, llvm@lists.linux.dev
Subject: Re: [PATCH] fs: Replace kmap{,_atomic}() with kmap_local_page()
Date: Sat, 09 Jul 2022 20:30:28 +0200
Message-ID: <5600017.DvuYhMxLoT@opensuse>
In-Reply-To: <YsiQptk19txHrG4c@iweiny-desk3>
References: <20220630163527.9776-1-fmdefrancesco@gmail.com> <YsiQptk19txHrG4c@iweiny-desk3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On venerd=C3=AC 8 luglio 2022 22:18:35 CEST Ira Weiny wrote:
> On Thu, Jun 30, 2022 at 06:35:27PM +0200, Fabio M. De Francesco wrote:
> > The use of kmap() and kmap_atomic() are being deprecated in favor of
> > kmap_local_page().
> >=20
> > With kmap_local_page(), the mappings are per thread, CPU local and not
> > globally visible. Furthermore, the mappings can be acquired from any
> > context (including interrupts).
> >=20
> > Therefore, use kmap_local_page() in exec.c because these mappings are=20
per
> > thread, CPU local, and not globally visible.
> >=20
> > Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
> > HIGHMEM64GB enabled.
> >=20
> > Suggested-by: Ira Weiny <ira.weiny@intel.com>
>=20
> This looks good but there is a kmap_atomic() in this file which I _think_=
=20
can
> be converted as well.  But that is good as a separate patch.
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>=20

Thanks for your review!

I didn't notice that kmap_atomic(). I'll send a conversion with a separate=
=20
patch.

=46abio



