Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEC51846
	for <nvdimm@lists.linux.dev>; Wed, 27 Sep 2023 01:18:47 +0000 (UTC)
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-77433e7a876so325033085a.3
        for <nvdimm@lists.linux.dev>; Tue, 26 Sep 2023 18:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695777526; x=1696382326; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LtwNx0bbAtYKFwMATRYOsNB6/aB6xeUP5MHzuRhubV8=;
        b=XB8x3aS+bBwEr6VZIRtLVvH8QvV+kyHhHM+g4JjQF62ZSC5VGyPSf8GETUVdnO9yuS
         Wpt0Ap+9vWAEnNfAcc2Ontcy5OBSOT3VedVixUIQCFBZ5nA1oCEw2QEAmbnGukdhlOyQ
         Nf9pFyZPO+pFkTqhVc2rctLxo71weyEwmb/Cq8xZERDd2wK2YUFBbtIQwcq7oXULVL36
         2vWxYBFDaQ9sV7CyYxIEKSc26dXajWto2n4EnUPhONdU9UZun7Z2t4NyT7arONLVcuXg
         JaiBWalNNAP8sEZu2L7/IbE6dOQrVcuwJkDIwC4JhfP0XpEeGjAO6fuCj1NaQENsSFOt
         ViTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695777526; x=1696382326;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LtwNx0bbAtYKFwMATRYOsNB6/aB6xeUP5MHzuRhubV8=;
        b=exWic8JxtJlIqpAAUGVhR8xSfa8bjEwA3ji6Ge81VcMJ7cLPH1Os93dlpgieWYckrm
         gBu89PFd9RlfjWz46iSyBslbLFlmN9sbgQzaT2BzyMS5IBnMnsrVIVNLdNei4VSbL6sS
         MED/r34aOWM0zCR9XiBvQabcVlhd1Bkl5mVy3dYEOrsJ5RYUPbvj8KW4lz5rSeoZw4nU
         zw2QAXrY+A7P2PkEfxMjK9u8joCih19zZTTc2M4RjWtPqO5La63LqG5JKp0cpGlkFjrW
         ogSgHMnO84EkF2JCdYE6tTzVjV1slJHsKDFzvH3iYjD7Mz0mRNcc3NLV+re/E0Njjdg6
         Lh7Q==
X-Gm-Message-State: AOJu0YxQgZwcQ+ANJCut6rzkMkX9vpKLEepb5QgtLTjv6RMHH2QghWlt
	ASQMPhXbZ7NFoXc33mZVBaUm4Q==
X-Google-Smtp-Source: AGHT+IGMERguD8Nbh7njgpyWv8MTtUkMcRbsGHRvIE69chNK2m7X1prW1+mTzN4JrcPj+g12qemmFw==
X-Received: by 2002:a05:620a:1218:b0:774:1e8a:3182 with SMTP id u24-20020a05620a121800b007741e8a3182mr427232qkj.26.1695777526164;
        Tue, 26 Sep 2023 18:18:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id c14-20020aa7880e000000b0069100e70943sm10595329pfo.24.2023.09.26.18.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 18:18:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1qlJCM-0064Mq-0S;
	Wed, 27 Sep 2023 11:18:42 +1000
Date: Wed, 27 Sep 2023 11:18:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, chandan.babu@oracle.com,
	dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <ZROC8hEabAGS7orb@dread.disaster.area>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926145519.GE11439@frogsfrogsfrogs>

On Tue, Sep 26, 2023 at 07:55:19AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 21, 2023 at 04:33:04PM +0800, Shiyang Ruan wrote:
> > Hi,
> > 
> > Any comments?
> 
> I notice that xfs/55[0-2] still fail on my fakepmem machine:
> 
> --- /tmp/fstests/tests/xfs/550.out	2023-09-23 09:40:47.839521305 -0700
> +++ /var/tmp/fstests/xfs/550.out.bad	2023-09-24 20:00:23.400000000 -0700
> @@ -3,7 +3,6 @@ Format and mount
>  Create the original files
>  Inject memory failure (1 page)
>  Inject poison...
> -Process is killed by signal: 7
>  Inject memory failure (2 pages)
>  Inject poison...
> -Process is killed by signal: 7
> +Memory failure didn't kill the process
> 
> (yes, rmap is enabled)

Yes, I see the same failures, too. I've just been ignoring them
because I thought that all the memory failure code was still not
complete....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
