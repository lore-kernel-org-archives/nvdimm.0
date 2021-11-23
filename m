Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD4572
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 19:33:56 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id n26so292691pff.3
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 11:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hj7PcxuLnKzRepBdxbumr3rSJH1rp9RXoQiNS6BkqqY=;
        b=jjyjzax1feHZ07LUiZ/Yf1E9Hxm1wgDLlAZ2cYg6AJFLe/d321qFax/yEEu22m6fed
         iBHNc8Kk34bMQQ2nIQi6MEMltBfNwsAHFQR0AWSHQwNal+nFXc7edty5ia7jOUicLQW1
         FuRddFObFySh+nkUL24rBP+JDHWbRQRoHp4NV/QyPAV4R/iAhHEl65ZT4s43voxcaEMy
         Oc8zToerc/pGHUlRu2jWA79GIW6I3ZHT1zjOZ64ig8LsDtvPs4/T2LyRFd31HHpRYYun
         TIkUF+RfmunDs0Ue5w+xrykDMWgvw58GCXj/wKIs5Ax9Klji3Cu6QKxzZO3Z0ZwENfiJ
         dDSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hj7PcxuLnKzRepBdxbumr3rSJH1rp9RXoQiNS6BkqqY=;
        b=SdReqf3/VmR4qWYoNm+DQG7fTLaFqSJK9N7jsDs1IgiJXtwZhRfn3NwMHQjhCGdIyb
         CMfmkgok1VUMQsJ/aAVSnEWXtQ6M0inyKxP2buM0ti6REmEMV3Ns9VQUv5ei/d+o2P20
         iD6asp51KJiTiLwKks4Rjwi97HRthhlN/vNxBbv/ov16GFANxKvAfwbuo3vBNQhedM8S
         PHRd+jB33B/U121EFTv3CaLk7rlJn4qF/gYMUgtJiFC7olIu1wog1Ov/+yWHxJx68yvw
         G2oiGPiADpuclJbLmqwSG2vuNo7/HPvrPp0KV/KbmjG4qt9ib5awD5GRxN/rzNok8rHt
         lzsw==
X-Gm-Message-State: AOAM531fR6zYEQzpqOqxM56qKOW6XwBVug0lmY477rnJ4kc4FJKnfaN8
	P0rgf0ZB8ufqH1+6GHAnpYN7ypEnHAjHJ3UtMDYTKA==
X-Google-Smtp-Source: ABdhPJzfbK/HXngr7c4SVqoUjU1z90TEgx7yZs5kS94X6ib8WevHTs6s6Lbm19DO5En0QIDCaOcGr0Q9P6r3KEtQ2kY=
X-Received: by 2002:a63:85c6:: with SMTP id u189mr5465536pgd.377.1637696035778;
 Tue, 23 Nov 2021 11:33:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-5-hch@lst.de>
 <CAPcyv4ic=Mz_nr5biEoBikTBySJA947ZK3QQ9Mn=KhVb_HiwAA@mail.gmail.com> <20211123055742.GB13711@lst.de>
In-Reply-To: <20211123055742.GB13711@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 11:33:45 -0800
Message-ID: <CAPcyv4jd2eUo4bDfX=idG7js6W=L8uKKveG97r1a8DWa-pJ=mQ@mail.gmail.com>
Subject: Re: [PATCH 04/29] dax: simplify the dax_device <-> gendisk association
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 22, 2021 at 9:58 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Nov 22, 2021 at 07:33:06PM -0800, Dan Williams wrote:
> > Is it time to add a "DAX" symbol namespace?
>
> What would be the benefit?

Just the small benefit of identifying DAX core users with a common
grep line, and to indicate that DAX exports are more intertwined than
standalone exports, but yeah those are minor.
