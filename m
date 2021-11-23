Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B92C83
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 21:48:34 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id y7so228249plp.0
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 13:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TYkPf9vJ648gXjsCEnGEexU4+Ifkiqg1wwbcGn6CCJ4=;
        b=VQApAlcktwMcpaq5jFhkMxeNGyvexkKC3i6bBW7J48mF8DsF1/7CQAqKNzOE+eTccI
         MukZz7spVxbYqcrXVw8V1NPJ/pO4n52l7m+S0Ph4Ybr+mw2kgqAqtZa3pLex/+BZstf8
         /wFsj02Qj6TChPn0/3voEI1RYYWUipBK72irmVx+QhYrnrndgBztGcQeijJ0cPmWiSB8
         zysPKFzjgdDt9boZOOp48eyCMBg3PV9MBTwiNrvClt0hBzUO02OKjJgpyz/mrusiP8R+
         CYs52zo3lmHwTSmYl1Jahz6zyoWzMdW1LqR6lyuLMEqjEjPScDcZZh/xx6IU/yB7SEwD
         h9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TYkPf9vJ648gXjsCEnGEexU4+Ifkiqg1wwbcGn6CCJ4=;
        b=a1tjKuAbyrQ6HV+5/7dvFSYFzDxV/Qy6eIpK5teUS9mmBMhGdF2BLrPrbeaQ2BCRD4
         8qDHVMUd+0StxZ7xGcNUnchjWP2NFQlPvj941vhSKZCmk+Bu5sJWBXEipd1/78R8tsZa
         HXh91nOkKzKDZ59FqEpnXUZrZKtMOeXwQ9pHhqFmxrhCszmPiPEh5PMlQiachkBybbbB
         6sWRPABmLf3fUCkrFZFTtoBLtG4/TSAYliKCmTPUNnQxexN5KfN6CHL8OdDMPlaNwZj0
         SEEZHnVBgNTvZqCtpxiNagXaG4cIxR5W8IoKFNpBvZFzNFci9+THs/qcKYXWs2uZrH7U
         g1aQ==
X-Gm-Message-State: AOAM532EQcPAxTxZQm9dvEg47iwzOFCQ+ooN120T9zzV5TGvVYsWRTa+
	9geIenIs4CsKqeDUutbm17fvbwPXHPVu/X0kJ7mMUg==
X-Google-Smtp-Source: ABdhPJyT9foSDeohZagrJ9StTFco2dwZgw3K6Q2oNHo7YSNAudlmobBOmJCjxwVnaF6MiMXxVYrJ5EOKlp8j1MbCkKE=
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr7435174pjb.8.1637704113737;
 Tue, 23 Nov 2021 13:48:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-20-hch@lst.de>
In-Reply-To: <20211109083309.584081-20-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 13:48:23 -0800
Message-ID: <CAPcyv4isfhSxr+MJnw2UBCFN_3_dCzwAjJERHzycnR5Ncy2RQQ@mail.gmail.com>
Subject: Re: [PATCH 19/29] ext2: cleanup the dax handling in ext2_fill_super
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Only call fs_dax_get_by_bdev once the sbi has been allocated and remove
> the need for the dax_dev local variable.

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
