Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D812FAF
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 16:07:41 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id q2so9609627pgt.6
        for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 09:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=epIvCzmEqd8lfEkp+zSX1z8FhC6G4rECGu8AkMD5cjk=;
        b=P7Uh70GB0OX3B5Tk5r5zIxGh0NGQ540vdB1mNKc2+JutGdaZMDOkgUxO7d7iWDuhYZ
         z1tCB9283izawrMkSTNVGS7wgAXNGmlA3+Cr1pWkT1AUl7J8yzzbAfduwNz8D3V9fHfW
         6RZt94rmopS/jx/A8V3arfNqYRWF4Gb2BH8IG7P2QkRuA12Qi+9LAd16WMy1VBKta2EW
         6fU2eSUDVOsSjU2nRgaifSK1mQmCZIk5O3n/hYxktE56ZNMrEERZzMgxXuvQoedf5AQ1
         +n2gl1cUovGWZFtsMrCPt+gUTucffn2xvgJEpGG8k+mhCO/9SqQlDQ6VWtpgkGfa16cD
         fs1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=epIvCzmEqd8lfEkp+zSX1z8FhC6G4rECGu8AkMD5cjk=;
        b=sXwMvUl4fNBF0ascFQ2gM0X+MZa9QGTjrThUYbdVeZlZorQcnnEQdgbhOGKNwOPXhh
         bi2avY6zsmluW3ZsYI1iGrvjk3Wa1US9RymsR1gvn6eYKmq4aWcgzO6YdeBMy8RfIWOS
         HQvmJBArZuFizPLwLJILX4utbeja68FyI6WKrIzPWPPqmAFO5Cuyvr1i/nB1VzG+FFpS
         D747xnzYSoeC6m5ezBQeXv6RMZcUxhUYSB/OEiXSiI1VNzmfIe82nCKOX6NeNhU53Xjn
         C3HTJGasHLp61kpg2ix9gwMKWjiXIwYmc/XCKVdH0XgGBHaweMO8Li38V+CoXcQkpav1
         KnEQ==
X-Gm-Message-State: AOAM531IFWaX2xArAZNmj2lyHSienjcRr+W7WzPLx9In33hGvF1hWLGz
	BmClPa5sOAsloF7+sI52ZcApJaB2txNRTwZM2sZpPg==
X-Google-Smtp-Source: ABdhPJxyfy7kK0en0qSo4G5Lluu8ZezasgOhs9PpGIhkynMyXLeeasrkdLx8NF/nNzuMhI/nhpOTrwat9vU59+Lgzvc=
X-Received: by 2002:a05:6a00:9a4:b0:3e2:f6d0:c926 with SMTP id
 u36-20020a056a0009a400b003e2f6d0c926mr13253034pfg.31.1629475661105; Fri, 20
 Aug 2021 09:07:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com> <20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 09:07:30 -0700
Message-ID: <CAPcyv4h0p+zD5tsT8HDUpNq_ZDCqo249KsmPLX-U8ia146r2Tg@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 1/9] pagemap: Introduce ->memory_failure()
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	device-mapper development <dm-devel@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>, 
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> When memory-failure occurs, we call this function which is implemented
> by each kind of devices.  For the fsdax case, pmem device driver
> implements it.  Pmem device driver will find out the filesystem in which
> the corrupted page located in.  And finally call filesystem handler to
> deal with this error.
>
> The filesystem will try to recover the corrupted data if necessary.

This patch looks good to me, but I would fold it into the patch that
first populates ->memory_failure().
