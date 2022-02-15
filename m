Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2755E1B64
	for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 22:11:49 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso4498197pjt.4
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 14:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dg8Bbqo8xrTURRSZr1gbJA1kXH+dR6Cfw/CPc1vh5OA=;
        b=JWDZBiIvBXJ+xyw/ssMlbLaY+HL0dGj6fRKKopQM/zAdOrPiEpBBbN0hIHBWPjTwv7
         phWt006J1z/OGnlE0pZ1IAr4MBG61MAESVtMLCJJLdN03Qgw5ph3ybjNDcm5KLD4H/Bn
         dWXl2k4tg6j6b6r3iLke/JjQOqtAWGhWjmz+5X/AmIsbrRbdPwocCDW6gnbjWLV+8CGP
         6XBgMZj2Vbtv7WovHLG8U9O+XTiFW1Esdpsq5PDNf7YwiqhlubKB9tjZcJrQw+cD3SxG
         3OYRHWmQVG+2jcAaW9y66JUIwQHgJwy+IQgpES3zBB50Hn7Ps4/BtqJ1QikahSxmXMbV
         ZLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dg8Bbqo8xrTURRSZr1gbJA1kXH+dR6Cfw/CPc1vh5OA=;
        b=zHK0JhpSKDnkiX2MFdEX8a4Q9Va4dN5tBGDa5GQgUs/Hc5ooNOcVY3AI4FRaQPugJx
         SIRJ8YoKNCx65RMG57D4D4FV2QlvKsGMu6cL/BehbPdptVLTnTsh+jIHZ86h+HzO+3y4
         SsI8wMAbFnA1zD4Z7/5G11rado5OwTv0EYlMWs/5iK1Nw23ObGh9sJuJIalUsuIPWEya
         nUi4k/TxhOT10KHyzIf7LyjOlZMppShPZG9zxzCHvRYlZsD9V28mlXzpMHcRDp8b1/PL
         8MUTcQZI7rf6UpJpJaS5PjJNec32fo3q0JX0ewWJ8MO5kJ8yrP3lOrNEfTOnEQIB2ipj
         J3AQ==
X-Gm-Message-State: AOAM533eYnLnQ8ZKgY19Wv6QAlbbCzVKXtJG7PsRfPMKHOvyKDIJ4AWB
	HqFDJdIWHekybEvvTmgF8DyicwJteKw1DC3h+aIPWQ==
X-Google-Smtp-Source: ABdhPJyiswDhX6qkwwQts1SFepTHj/P5w6WGlYQlgTjrpG3xns33VOfe9EvdjD9DCBoIscPBLRLRybo05bZTeUzOoys=
X-Received: by 2002:a17:90a:e7cb:: with SMTP id kb11mr1046139pjb.220.1644963108677;
 Tue, 15 Feb 2022 14:11:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com> <20220127124058.1172422-3-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220127124058.1172422-3-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 14:11:42 -0800
Message-ID: <CAPcyv4jMBm3ewWeQX7eZDaHT4aD8eOPcxYBiiZT1ZmaV9z-A2g@mail.gmail.com>
Subject: Re: [PATCH v10 2/9] mm: factor helpers for memory_failure_dev_pagemap
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> memory_failure_dev_pagemap code is a bit complex before introduce RMAP
> feature for fsdax.  So it is needed to factor some helper functions to
> simplify these code.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
