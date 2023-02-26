Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC51291F
	for <nvdimm@lists.linux.dev>; Sun, 26 Feb 2023 23:51:01 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id x34so4395206pjj.0
        for <nvdimm@lists.linux.dev>; Sun, 26 Feb 2023 15:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZRz1s/KRyO2Uxle7inVvqWM+4+Zegth9BIYrB8VHgJo=;
        b=Mk9tRRfW308oYU3sLQ9yDdi2b3JL5istzYA1UAT00A3pKm3FAvG/xGqJ5/miW1RysM
         /CqsMcjdybw8Bo9iiRVpNU4Umt6d5Gt9dh5zmiVrlCp7366v3Ujk/vxERazGT2EObXDs
         E2ROzMGJwFWIVc/swERCL/ssQ2fhO90sCYWSVt1gUFeIUCyhCIHM4BDpaJn9PMlH+CTW
         Upx+Na8pZmYuq4FwymuNcI8m2JTDaJmk4E8oui+2O4xDj3fWiLc1QFoWfPpoYniyuSoI
         qsEGgGD9WGutpkTiQ3JcoO3/2xVfqOozEew6jMBI54emEqIMDlChsH8cQpY7QSG4Os5Z
         lG2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRz1s/KRyO2Uxle7inVvqWM+4+Zegth9BIYrB8VHgJo=;
        b=7pCzczg42TZ769BGw+z7FVUrbUREPAhkETkpZ42p++hQwqZKm8UX+Bntv7Iiq+ylnh
         EZEVmozYa58jxOyZjHVtjbIV0O7TMFThDR6Q4QBAQWMOdE5vmZQmZ6Slh8KZqQ8ZQ6AA
         w0127DX18TUl+6SPXXeHWEVeMGVzjMA84AZoycUVYjkO3OnMClaC8TK19B0py/5fXsEs
         b2foBe0n60LpvCAvdMZJLqSqGFOOriNel2gPEytWuX2gMCMMY2JEGAQaj09FRqLQvp8z
         woYhNDMfzxxP8yuZbiiiyZ01BVlE5rqs+OzZH4Qs/oDBMa2SiL11KndmlHNLDLSPNCJF
         9/Ig==
X-Gm-Message-State: AO0yUKUKU0OhxG3RPOjPipQfJOuoa6fEXSt/eWM2zSAg3p+0kOrIK790
	uwnVRPNjiCXG3COLUB7RbNHf6Q==
X-Google-Smtp-Source: AK7set9nFy4/f6XcyXZVPqFl639UstSp++qbIKME5kqRCmc5ElckiPp+IUv8d1xCQl78ZiAXr5MTlg==
X-Received: by 2002:a17:902:eccc:b0:19c:387c:bd65 with SMTP id a12-20020a170902eccc00b0019c387cbd65mr28220861plh.10.1677455460789;
        Sun, 26 Feb 2023 15:51:00 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902aa8d00b00198d7b52eefsm3129186plr.257.2023.02.26.15.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 15:51:00 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1pWQnB-002WaD-LN; Mon, 27 Feb 2023 10:50:57 +1100
Date: Mon, 27 Feb 2023 10:50:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	djwong@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	jane.chu@oracle.com, akpm@linux-foundation.org, willy@infradead.org
Subject: Re: [PATCH v10 2/3] fs: introduce super_drop_pagecache()
Message-ID: <20230226235057.GY360264@dread.disaster.area>
References: <1676645312-13-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1676645312-13-3-git-send-email-ruansy.fnst@fujitsu.com>
 <20230220212506.GS360264@dread.disaster.area>
 <b872f2e8-c451-697b-e9cf-63c5bae52a8a@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b872f2e8-c451-697b-e9cf-63c5bae52a8a@fujitsu.com>

On Tue, Feb 21, 2023 at 09:57:52AM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2023/2/21 5:25, Dave Chinner 写道:
> > On Fri, Feb 17, 2023 at 02:48:31PM +0000, Shiyang Ruan wrote:
> > > xfs_notify_failure.c requires a method to invalidate all dax mappings.
> > > drop_pagecache_sb() can do this but it is a static function and only
> > > build with CONFIG_SYSCTL.  Now, move its implementation into super.c and
> > > call it super_drop_pagecache().  Use its second argument as invalidator
> > > so that we can choose which invalidate method to use.
> > > 
> > > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > 
> > I got no repsonse last time, so I'll just post a link to the
> > concerns I stated about this:
> > 
> > https://lore.kernel.org/linux-xfs/20230205215000.GT360264@dread.disaster.area/
> 
> Please see patch 3.  I changed the code: freeze the fs, then drop its
> caches.

Neither the patch nor the cover letter have a changelog in them
that mention you changed anything. Please, at least, keep a change
log in the cover letter so that people know what has changed from
version to version without having to look at every patch and line of
code again.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
