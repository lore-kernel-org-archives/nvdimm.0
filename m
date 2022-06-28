Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58B6362
	for <nvdimm@lists.linux.dev>; Tue, 28 Jun 2022 07:27:37 +0000 (UTC)
Received: by mail-qv1-f53.google.com with SMTP id c1so18764854qvi.11
        for <nvdimm@lists.linux.dev>; Tue, 28 Jun 2022 00:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hwgLtruPC06mcRCnQAsf+kJqHCP1mf00hTNnpiQ34M0=;
        b=kvef8EdkzTmjSOcDmEv8cJrFuoX36xT42Yk6eTEqaZoViuBDEWUGzj+cIkq1lwZ0cI
         ZyWCSnt72Msy854/jtnEOnyD8pAqdDXM1Mjg1ycj1h/745UoFApQatufB/EpGWyHuO8x
         wFAxroEwE9V+i9pO8WzHZt6Wf8aYdhFcoeSuSo2YQdJziMYbLxcDLwreSLT16j3bLHDY
         r5JlzHIb50E1k03xjmp/qv4D3laO6vsHfHkQNkUdR4N7SE8aeWOttvVC/DTqP8FV0y4I
         AQakXhz/ulCJ1iLS4Wjjl+K+vdd5UHWP6OJM47wOYhEucQPa2HxUlIA+9rUnZSwXgnuS
         lbDA==
X-Gm-Message-State: AJIora/hgPgkwSd2jm5U3NDMScN5G04GCSVaR4O3+whds6gknIc2COd+
	jGNkXS4djZslAT4Rzcvsc2aF7P3Jh46jEaiG
X-Google-Smtp-Source: AGRyM1th8YLN4T/LN5XfgF325yh1JJVvEz37oKjKC/TDbVhjycoT6rUVhWywW0u9iyVADpwe1181pg==
X-Received: by 2002:ac8:5bd4:0:b0:31a:faa2:f639 with SMTP id b20-20020ac85bd4000000b0031afaa2f639mr5068801qtb.487.1656401256795;
        Tue, 28 Jun 2022 00:27:36 -0700 (PDT)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id w11-20020a05622a190b00b003162a22f8f4sm3534655qtc.49.2022.06.28.00.27.33
        for <nvdimm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 00:27:34 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-318889e6a2cso107416087b3.1
        for <nvdimm@lists.linux.dev>; Tue, 28 Jun 2022 00:27:33 -0700 (PDT)
X-Received: by 2002:a81:a092:0:b0:318:5c89:a935 with SMTP id
 x140-20020a81a092000000b003185c89a935mr20762801ywg.383.1656401253054; Tue, 28
 Jun 2022 00:27:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220627180432.GA136081@embeddedor>
In-Reply-To: <20220627180432.GA136081@embeddedor>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Jun 2022 09:27:21 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
Message-ID: <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
Subject: Re: [PATCH][next] treewide: uapi: Replace zero-length arrays with
 flexible-array members
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "the arch/x86 maintainers" <x86@kernel.org>, dm-devel@redhat.com, 
	linux-m68k <linux-m68k@lists.linux-m68k.org>, 
	"open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, 
	KVM list <kvm@vger.kernel.org>, 
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>, 
	DRI Development <dri-devel@lists.freedesktop.org>, netdev <netdev@vger.kernel.org>, 
	bpf <bpf@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, 
	linux-can@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	linux1394-devel@lists.sourceforge.net, io-uring@vger.kernel.org, 
	lvs-devel@vger.kernel.org, MTD Maling List <linux-mtd@lists.infradead.org>, 
	kasan-dev <kasan-dev@googlegroups.com>, Linux MMC List <linux-mmc@vger.kernel.org>, 
	nvdimm@lists.linux.dev, NetFilter <netfilter-devel@vger.kernel.org>, 
	coreteam@netfilter.org, linux-perf-users@vger.kernel.org, 
	linux-raid@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, scsi <linux-scsi@vger.kernel.org>, 
	target-devel <target-devel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, 
	virtualization@lists.linux-foundation.org, 
	V9FS Developers <v9fs-developer@lists.sourceforge.net>, 
	linux-rdma <linux-rdma@vger.kernel.org>, 
	ALSA Development Mailing List <alsa-devel@alsa-project.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

Thanks for your patch!

On Mon, Jun 27, 2022 at 8:04 PM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use =E2=80=9Cflexible array members=E2=80=9D[1]=
 for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].

These rules apply to the kernel, but uapi is not considered part of the
kernel, so different rules apply.  Uapi header files should work with
whatever compiler that can be used for compiling userspace.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
