Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6E03D68
	for <nvdimm@lists.linux.dev>; Mon, 27 Jun 2022 19:53:47 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id r66so10071020pgr.2
        for <nvdimm@lists.linux.dev>; Mon, 27 Jun 2022 12:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k/l4LcE4w+6LYrCo6/Ek+44r04gbnpHm9yyPA0qKR6A=;
        b=ryYp2naL1201DMNfPmSbpexCs+zqiLsBQDBXHc9esFHxBJ8Ep2LLrsgHtxJtosu2+J
         1iBYfvQQXv6NYwKQ2qXQCc4mHXYQGPYeeUC3hu2OgPUPjZXH+3Hi6Zqo5SyTeGerBVQA
         p1Bh5daOuP6Q9UMRPxlj6vxZpUjBpxOPEYhjttl3pP6gtksJnO1wA5G3ERXmm3iOhFrs
         MlyYmEaZt8I/cdZ0xlE1RQA9V/oE3k4e+iV7r8nrUlXmSvlRImOQktUmXD254MFh7ceV
         2zbWTxt+/QD0MTYLBrv8xqePAliI2A59OkEqXOPrksIatTeOcW53aiRz+65e7KopsoX+
         3osw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k/l4LcE4w+6LYrCo6/Ek+44r04gbnpHm9yyPA0qKR6A=;
        b=1iTBZzqjuHDsi64q2l9IdouzLeyabxSJEXr3K16TS2dkf6uCx/mUhMrfqYBZkK4B/w
         unZfJ6b5XETnWMMyOjH6EwP30EMzH/en/rIdW8pnla0h1VL/gZEjtXjfIkfDLyWgKxz/
         nIlDIKh2dRdEsd9MPi7MxHzFL4qgl9jvKSg8ai8Vz+qp/vpKrP65yn55HPkXEib3/ZbT
         IIxn02v5Weuw0TGRiNYQeEDWzowSgeBNT9HGf2nlbzUy90mMzTRcOZeV2sjdCrYxPrH0
         6Aho2LfQV1XvFXTWfjMcqZViH7tTEyhwMiVas0JeW9F5MxUSSUNOhth6VO5aMQedoikq
         mUjg==
X-Gm-Message-State: AJIora9Xw21fLSco5ryzPumSt9WtXL4NHnub0ZQE6MC1rC4V7etAjLzO
	aNMlKcbgKpHO8SjG6R15ApFdbA==
X-Google-Smtp-Source: AGRyM1ssDeW6Ux1oaY9ixgaaapzXMFszbxcRVeOWaHAYiiaVMZ4HUYtPzqxXzR6I8+fqeJNf8u9hpg==
X-Received: by 2002:a63:7a5d:0:b0:40c:fcbe:4799 with SMTP id j29-20020a637a5d000000b0040cfcbe4799mr14428539pgn.297.1656359626928;
        Mon, 27 Jun 2022 12:53:46 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id c16-20020a056a00009000b0051c1b445094sm7821510pfj.7.2022.06.27.12.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 12:53:46 -0700 (PDT)
Date: Mon, 27 Jun 2022 12:53:43 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
 x86@kernel.org, dm-devel@redhat.com, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
 bpf@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-can@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux1394-devel@lists.sourceforge.net, io-uring@vger.kernel.org,
 lvs-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
 kasan-dev@googlegroups.com, linux-mmc@vger.kernel.org,
 nvdimm@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-perf-users@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-usb@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 v9fs-developer@lists.sourceforge.net, linux-rdma@vger.kernel.org,
 alsa-devel@alsa-project.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] treewide: uapi: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220627125343.44e24c41@hermes.local>
In-Reply-To: <20220627180432.GA136081@embeddedor>
References: <20220627180432.GA136081@embeddedor>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Jun 2022 20:04:32 +0200
"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use =E2=80=9Cflexible array members=E2=80=9D[1]=
 for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
>=20
> This code was transformed with the help of Coccinelle:
> (linux-5.19-rc2$ spatch --jobs $(getconf _NPROCESSORS_ONLN) --sp-file scr=
ipt.cocci --include-headers --dir . > output.patch)
>=20
> @@
> identifier S, member, array;
> type T1, T2;
> @@
>=20
> struct S {
>   ...
>   T1 member;
>   T2 array[
> - 0
>   ];
> };
>=20
> -fstrict-flex-arrays=3D3 is coming and we need to land these changes
> to prevent issues like these in the short future:
>=20
> ../fs/minix/dir.c:337:3: warning: 'strcpy' will always overflow; destinat=
ion buffer has size 0,
> but the source string has length 2 (including NUL byte) [-Wfortify-source]
> 		strcpy(de3->name, ".");
> 		^
>=20
> Since these are all [0] to [] changes, the risk to UAPI is nearly zero. If
> this breaks anything, we can use a union with a new member name.
>=20
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-le=
ngth-and-one-element-arrays
>=20
> Link: https://github.com/KSPP/linux/issues/78
> Build-tested-by: https://lore.kernel.org/lkml/62b675ec.wKX6AOZ6cbE71vtF%2=
5lkp@intel.com/
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks this fixes warning with gcc-12 in iproute2.
In function =E2=80=98xfrm_algo_parse=E2=80=99,
    inlined from =E2=80=98xfrm_state_modify.constprop=E2=80=99 at xfrm_stat=
e.c:573:5:
xfrm_state.c:162:32: warning: writing 1 byte into a region of size 0 [-Wstr=
ingop-overflow=3D]
  162 |                         buf[j] =3D val;
      |                         ~~~~~~~^~~~~
