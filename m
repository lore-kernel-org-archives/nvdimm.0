Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4731417EF
	for <nvdimm@lists.linux.dev>; Wed,  6 Jul 2022 02:47:36 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id y141so13160493pfb.7
        for <nvdimm@lists.linux.dev>; Tue, 05 Jul 2022 19:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IW/MEisRImp3/lPYkYpqCnuHv6idrwG0D60CzTjNlbg=;
        b=quxpqfHGltM89OLv0TIHtu7OKPWuWQXFLM4J5R8qY/nAAEfFdhcnS14yGAp7e1n5di
         0cPJ3TwSSrAVYbIoskwpc480ETBLPHs54TGThC3k8J6KBnpMusgr90miFBdiJXUsgyx6
         xbcBdflNaQMiKApuZJoTRU7zlZz1DXl+8lm3R3P+HoO978TYfORR5vSSDjUYmLmMp+q2
         8+aRcqXKO5YpZtPafnyRV4D8vzdXVFr3Rjt474WTm4VlDURJ0P/FMc8TZKJU2Zh/WdmC
         J5Q75J6DZ33YaXiwTDBD8ENDZbyIyeSUYrwFljyI0x6EjCVPN6pn2bzzWd7Pt1oEpfHk
         cdSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IW/MEisRImp3/lPYkYpqCnuHv6idrwG0D60CzTjNlbg=;
        b=tjXVhBduhZieeX+lGanpHr4Ic7eSZuMY9ixdjYce1Gi+zkHwU6NTsloqYYDcTKIiCK
         NxDYRcafDpL9looyM5DhaPMGY8jvTZxRl2sONUAh/0fJ/vKwTNIZAIRbBolA8O5mojfN
         vaMlEVaN79+8ONMlWqn5t/QOad+5pX5rbAWnSZrGf12sAiSBYBu2mjdEN5Sw/fLBax9y
         QtEBzvDDaW1xKmrnJSHeB4vY1UqF03sWTgH8e5SVO7nJNzV2kyWzfjzO74X85bxECwZA
         J9hdGCmX1FGsGOE7xuTzwUslm0KLvkxlOUoBJ+4WGeald6ode/OMmsqKr8E0STGGZCuK
         k6Dg==
X-Gm-Message-State: AJIora9WOUjEVw2GtTypYhLvrWr42qA/Sevo7PwOUhSBUuHoADwEV2B4
	s/B86kJUaKWo5jH1av5kETwLdQ==
X-Google-Smtp-Source: AGRyM1uTdJ3o4LNsP4D1e5S082o3mxjqvUnFNizEKLHJoOTPoitYvcw6+5ewIYS0dZ1OpE+R98mpjQ==
X-Received: by 2002:aa7:910b:0:b0:524:f8d9:a4c4 with SMTP id 11-20020aa7910b000000b00524f8d9a4c4mr45971995pfh.5.1657075655655;
        Tue, 05 Jul 2022 19:47:35 -0700 (PDT)
Received: from localhost ([139.177.225.229])
        by smtp.gmail.com with ESMTPSA id q13-20020a17090311cd00b0016bdeb58611sm6180279plh.112.2022.07.05.19.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 19:47:35 -0700 (PDT)
Date: Wed, 6 Jul 2022 10:47:32 +0800
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, jgg@ziepe.ca, jhubbard@nvidia.com,
	william.kucharski@oracle.com, dan.j.williams@intel.com,
	jack@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: fix missing wake-up event for FSDAX pages
Message-ID: <YsT3xFSLJonnA2XC@FVFYT0MHHV2J.usts.net>
References: <20220705123532.283-1-songmuchun@bytedance.com>
 <20220705141819.804eb972d43be3434dc70192@linux-foundation.org>
 <YsTLgQ45ESpsNEGV@casper.infradead.org>
 <20220705164710.9541b5cf0e5819193213ea5c@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705164710.9541b5cf0e5819193213ea5c@linux-foundation.org>

On Tue, Jul 05, 2022 at 04:47:10PM -0700, Andrew Morton wrote:
> On Wed, 6 Jul 2022 00:38:41 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Tue, Jul 05, 2022 at 02:18:19PM -0700, Andrew Morton wrote:
> > > On Tue,  5 Jul 2022 20:35:32 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
> > > 
> > > > FSDAX page refcounts are 1-based, rather than 0-based: if refcount is
> > > > 1, then the page is freed.  The FSDAX pages can be pinned through GUP,
> > > > then they will be unpinned via unpin_user_page() using a folio variant
> > > > to put the page, however, folio variants did not consider this special
> > > > case, the result will be to miss a wakeup event (like the user of
> > > > __fuse_dax_break_layouts()).  Since FSDAX pages are only possible get
> > > > by GUP users, so fix GUP instead of folio_put() to lower overhead.
> > > > 
> > > 
> > > What are the user visible runtime effects of this bug?
> > 
> > "missing wake up event" seems pretty obvious to me?  Something goes to
> > sleep waiting for a page to become unused, and is never woken.
> 
> No, missed wakeups are often obscured by another wakeup coming in
> shortly afterwards.
> 

I need to clarify the task will never be woken up.

> If this wakeup is not one of these, then are there reports from the
> softlockup detector?
> 
> Do we have reports of processes permanently stuck in D state?
>

No. The task is in an TASK_INTERRUPTIBLE state (see __fuse_dax_break_layouts). 
The hung task reporter only reports D task (TASK_UNINTERRUPTIBLE).

Thanks.
> 
