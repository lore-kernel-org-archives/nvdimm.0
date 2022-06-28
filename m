Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC223D98
	for <nvdimm@lists.linux.dev>; Tue, 28 Jun 2022 18:05:55 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id t21so12731710pfq.1
        for <nvdimm@lists.linux.dev>; Tue, 28 Jun 2022 11:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pTcGgtfSu6n7KkCWKQ4ciWe5XeKK5S4riO8KfNVW7Ig=;
        b=F/CZTCTDOlhkWqZ+vOzW0DaoZ/EZ1dOhoCSSJ2RrwBNwuY7CCyvEtaLLk8DO+FYVI8
         oY1bh2Rw2NH/e7uwuajkABgxQQynq/vb9wDrQT1ziurYSmeBDoqa9s9XGmGLyXXXVu1m
         Ptj/OKkdrLcBprdD9gQ9RffSNU26yKh9HCJiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pTcGgtfSu6n7KkCWKQ4ciWe5XeKK5S4riO8KfNVW7Ig=;
        b=08o/oii9rIMU3jTYAh2+7+G+gHmkr8M/YxRGtNF6TrhwxWy222uDnFuOnss3e7jJ4z
         PJvRF5FWw24r/6rjwJF/eNbzvcLS/3dknTdOKxpnBj4/woE9SauVA3ni1U7wQ4wCk6Q4
         GuyRFUfwTyB7rNjUfSRXGpD1od7IU7LtvjQkYgH8z/Thx2qWs+tzJynYlkYviFmPT0Yg
         C+RMTypwnX5dhn0thPDpgdHeVxwbtZ2VTU5I9ocyBTQ3nr5s7NkeYcOGfiZq+sn3jQiM
         xUhfVi90TF2zMBJBvbLfR3wKMtS001u5+1Fg2j+NQzauNKf27Vroeac+sN33cwxbplkF
         XRKg==
X-Gm-Message-State: AJIora+FkK/wRgmqTLYMPdP5po9vtyfFATqyijTxizxa0aFlRrS+yE/W
	7GkJnfEgmTqBE5DaBZTDqsJoWA==
X-Google-Smtp-Source: AGRyM1v6cdnwBfGpeB2JnkCbahQ14YUYaqjRd3VUKbR8YPBigZjfWVkzlvmFIFzfbBj+r2XqbA+86w==
X-Received: by 2002:a63:7412:0:b0:40c:fa27:9d07 with SMTP id p18-20020a637412000000b0040cfa279d07mr18441815pgc.27.1656439554674;
        Tue, 28 Jun 2022 11:05:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i3-20020a170902cf0300b0016a0ac06424sm9669985plg.51.2022.06.28.11.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:05:54 -0700 (PDT)
Date: Tue, 28 Jun 2022 11:05:53 -0700
From: Kees Cook <keescook@chromium.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>, dm-devel@redhat.com,
	linux-m68k <linux-m68k@lists.linux-m68k.org>,
	"open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	KVM list <kvm@vger.kernel.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-can@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	linux1394-devel@lists.sourceforge.net, io-uring@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	MTD Maling List <linux-mtd@lists.infradead.org>,
	kasan-dev <kasan-dev@googlegroups.com>,
	Linux MMC List <linux-mmc@vger.kernel.org>, nvdimm@lists.linux.dev,
	NetFilter <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
	linux-perf-users@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	scsi <linux-scsi@vger.kernel.org>,
	target-devel <target-devel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	virtualization@lists.linux-foundation.org,
	V9FS Developers <v9fs-developer@lists.sourceforge.net>,
	linux-rdma <linux-rdma@vger.kernel.org>,
	ALSA Development Mailing List <alsa-devel@alsa-project.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] treewide: uapi: Replace zero-length arrays with
 flexible-array members
Message-ID: <202206281104.7CC3935@keescook>
References: <20220627180432.GA136081@embeddedor>
 <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>

On Tue, Jun 28, 2022 at 09:27:21AM +0200, Geert Uytterhoeven wrote:
> Hi Gustavo,
> 
> Thanks for your patch!
> 
> On Mon, Jun 27, 2022 at 8:04 PM Gustavo A. R. Silva
> <gustavoars@kernel.org> wrote:
> > There is a regular need in the kernel to provide a way to declare
> > having a dynamically sized set of trailing elements in a structure.
> > Kernel code should always use “flexible array members”[1] for these
> > cases. The older style of one-element or zero-length arrays should
> > no longer be used[2].
> 
> These rules apply to the kernel, but uapi is not considered part of the
> kernel, so different rules apply.  Uapi header files should work with
> whatever compiler that can be used for compiling userspace.

Right, userspace isn't bound by these rules, but the kernel ends up
consuming these structures, so we need to fix them. The [0] -> []
changes (when they are not erroneously being used within other
structures) is valid for all compilers. Flexible arrays are C99; it's
been 23 years. :)

But, yes, where we DO break stuff we need to workaround it, etc.

-- 
Kees Cook
