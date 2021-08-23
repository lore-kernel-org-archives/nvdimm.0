Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5971972
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 16:48:43 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id mq3so12322952pjb.5
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 09:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DHjpXJVaorJJrONHThs2n/BVyyOjMaPVQq0TyoaLObU=;
        b=K4aPSagCbeW0et34hov0mWX89VGjBHt70OaTXNcqskc+Zzgcryf5LCb4YKOAiVzCB4
         PduovYBUnfaBuy5aPnbjX4Etn60IEtFClFgswwlTXmWMQqz5aCNeVIx7+HN2BjSILDK2
         03w5JFvHrHMXh9H3K2NWXqmlcI/ij2RcsnsZfEJyHWfNl/gx6JgWOy9Mi095I6rOi9BU
         2wOrbBtjyAg/u6ZjGLVDZyqgsn33kCp9FeO3+KKwCi/K7RyukQVv0Ohb5iV7MrU4Dwk5
         LziniW3UE8vIHivVj2QIjHptqmNTxA1VHrAPHSJuhRMI5v+dwUmyt0XRz4Wc0WMAbhjz
         TEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DHjpXJVaorJJrONHThs2n/BVyyOjMaPVQq0TyoaLObU=;
        b=VGKk/296lKzTFZqAKUv6QRoOFA9K3Pjvly0HUgJJpLmQkqP+MPDPagrTCTOpd3BLmT
         FE1iRvzzPwSX2dp7fKWMwlftkDwGbgkzk1inajdiDoek9jw05V05nsqgu7XZymGYMn4q
         rExXjaNUGJ4Jfnlt25aKEOZYidHpbNrEzdEXx05weAUNW1uPXnko8BOcZJErm0giZzpb
         3cq9vN8oiNbfXIeY77XOtgFwthHUyI/l0D3RRGLLg29zcXpHmHSQEf2I67b9dw9PFzWd
         8YQnT38ucHDoRYOR409+w4+c79GsvWgLGNyqANeTJULPsKGhriasPUo43JjPdCHWSwok
         8OnQ==
X-Gm-Message-State: AOAM53130FDpNfn4F7PzTVuFbudPzn9y96n1lfEGb9pL2wyAVFCrbXLC
	vx05C5aGMqWYp7Q358WWLDiwE9HlhMNO6Bbaq7F3XA==
X-Google-Smtp-Source: ABdhPJy+qNZNmxIul3yPPhfME5mYCBgn8upKUahPfXfj1jFqWcs4Eq1xQbDDVdK6Tzwd6GVD9cFFJVtkt3W6Lxln4B8=
X-Received: by 2002:a17:902:9b95:b0:130:6a7b:4570 with SMTP id
 y21-20020a1709029b9500b001306a7b4570mr17565813plp.27.1629737322913; Mon, 23
 Aug 2021 09:48:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210822203015.528438-1-qi.fuli@fujitsu.com> <20210822203015.528438-2-qi.fuli@fujitsu.com>
In-Reply-To: <20210822203015.528438-2-qi.fuli@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 09:48:32 -0700
Message-ID: <CAPcyv4imFbXW2_84QqmT+AmanXAtKXNQgKNEez3EX=o=XLiNjg@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/5] ndctl, ccan: import ciniparser
To: QI Fuli <fukuri.sai@gmail.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, Aug 22, 2021 at 1:36 PM QI Fuli <fukuri.sai@gmail.com> wrote:
>
> Import ciniparser from ccan[1].
> [1] https://ccodearchive.net/info/ciniparser.html

Hi Qi,

Vishal points out that an updated version of this code is now
available as a proper library that ships in distributions called
"iniparser".
