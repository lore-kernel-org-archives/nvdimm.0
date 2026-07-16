Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF17379987
	for <nvdimm@lists.linux.dev>; Thu, 16 Jul 2026 04:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784177720; cv=none; b=kA8mQY7o9YznxchNm3U3G6m105PdVInRStmb+t4/0MP6ApOhZAdkL5X0qB9JLRQSSeFFNTlFkWfr83NYX4bzQ/ZpLTwfyBX81Xda7fmqlBYmh4rpAnWOf7vL83N1fqdBt2hZf3yGGnw0jXDDwYI3uHesCviRkT3FFz3NF4ljDX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784177720; c=relaxed/simple;
	bh=AR41AGz1Ls+jbaJBGw54BAF0eERyApGv7PMgsDnE+IU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGZcnrl3y6kQv8WZ3PVYNlJ2Vbdmbezr4t96UJ+pDBlEM/Q3eF0LofIBSfvnTfFC1myF2pwLOEzwq5Kl9Ov4RBee0Z9NOGscDkX5qeOTG7SZOp9v7wkntgV60IL/UNSlAzyW2Znm9K7rOhe/9ASHuxMIMiMWMqtNRHY9QmRk9Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUHB2DX9; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUHB2DX9"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so4357277a91.0
        for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 21:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784177718; x=1784782518; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kGXsmEn3I6/Em//tCnrFWM7lx5yzqwvzso7DaerhRVU=;
        b=nUHB2DX90p3GClvjSlilirov/yqECG1yJIDoWNj4TcXWxOfMK5HatcsUTmYnMsUpVZ
         GDG7GDVuAPTgiFmHZkPywJzoegKSlW91kxLqBZAbdSRYtBoU+W+EVNF48p7WYtiBPur8
         UA5Aoqs2nbDILfDR5A82+GEtIV9MQlN5DWKE1RPcDUTVGvFiWRPluONJaHa9f5Lk92kl
         mWt7usAvDNlBt+JpY8ygVbf28jmsq27eZgqbW6WEl27e+We2m4DQ7UBReOdCWWgJ0l++
         7f6VHdVImd69kAfIC8JzEPKBYC81Qu+2DUM05vWe93wh3ewIo0y+f63mO9bYg6XtbQ9i
         uFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784177718; x=1784782518;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kGXsmEn3I6/Em//tCnrFWM7lx5yzqwvzso7DaerhRVU=;
        b=U2IIfn5tEasned3dqKehuXdOqgiSR0VR81jL013KlW3eI842WyNgAQJM2dX8ARuOTd
         n7MDcXBu+zPcvUIAv4wrYkmZiwD8Issn3y/nWYr/KlpDP1ulT9Gq/8HeKcYPGFt3cTBa
         DkfTIaSEzC35gax89cYo4EKBA1XeCZEaoRBcwjhgDam1GVZD/Wq4aP55Ov6dUVNxC/Fm
         aAEbR/f8kXpdigWqYc6/DP4RO+F6C+0C/w/0t8iqVQe5FrljWyGIgdFrD8lmfllFShyI
         eSxQaSwBZa2qO6xTuHPWB02xWRTCsM7F9uYOsF66CxoMOdIlMn07uxq4EOEYP93B/Tdh
         Rs2w==
X-Forwarded-Encrypted: i=1; AHgh+RoChMmkx99wsjls53A83THFjasM/iF08qm7IuqGc0Bclc6lg0rQM5D3xeKekYUZ/Gr/CXqhEBQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUiBpmDwvfM2a+aP3Vg1Ai3TFuqzHTFEKA7Jd8SL95vXveYKDV
	qB8dl5r8+KYkiL3IY0rSus2ZJtdZW/DRV7nXHPwwHVr511oSHqLsQRC4
X-Gm-Gg: AfdE7cm/BbyWQZyWYpF38MGe22cIfIsPwNexvOSbj5PgrHiI9YjVwEbldJPp+RIHl50
	AO+hTS3kcQfzs7A3AO3BCKxqzlPA+PKF/+V3RsV2zHJLcJvbklvQUx3DQSMyB6e/YLT4OuZhOTZ
	mLVwyhenm3NhDe16SnCF8FmsGa76ZmB/TJB4c+Nkv143Q7a1sUbV8cQ/J2gKDa9HhfpNgB2mf8z
	Mk0CSWUlkc8zDWgSI7ESpQ/5dH9uEqhLzS0D1/UxVIdkiFTqaSh3s8l69eQAJHPZ34qQf0UyjMn
	kIDVrjOdSy/Xki5y+X83pzqGQDl4LUwP4WYfdOyUIdwKAEJ6KK44ECY+LOLX57mDTEwXZdx963D
	q7NvPvkDdv6HMl5I32xGApe8FkM1DVkammMSYid68oYcTeT45KkcOWIr+FisZOfeu00S6IU5w86
	xnpPbor8gJ+ArwR/6F1wEUg2t4O1kmAdyXe4Q/tltqFJDVTL/TZIv+GCeyFggK3DWKjSf7
X-Received: by 2002:a05:6a21:4508:b0:3c3:9181:7d05 with SMTP id adf61e73a8af0-3c391817dc1mr628223637.68.1784177717966;
        Wed, 15 Jul 2026 21:55:17 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6a4866sm6761940eec.18.2026.07.15.21.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 21:55:17 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 15 Jul 2026 21:55:15 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v11 13/31] cxl/mem: Add 20 second timeout for stalled
 DC_ADD_CAPACITY chains
Message-ID: <alhkM7AUQ7dP_3bd@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-14-anisa.su@samsung.com>
 <3fb3b2c2-9be6-483b-94bd-d0515d5df9b2@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3fb3b2c2-9be6-483b-94bd-d0515d5df9b2@intel.com>

On Tue, Jun 30, 2026 at 02:11:12PM -0700, Dave Jiang wrote:
> 
> 
> On 6/25/26 4:04 AM, Anisa Su wrote:
> > A DC_ADD_CAPACITY event can span multiple event records grouped together
> > by the CXL_DCD_EVENT_MORE flag. Extents are staged in the pending list until
> > the last event record ('More'=0) is received, at which point the pending
> > list is processed. If the device opens such a chain (More=1) but never
> > sends the closing record, the staged list sits indefinitely.
> > 
> > Add a delayed-work watchdog that, on expiry, refuses the chain with an
> > empty ADD_DC_RESPONSE and drops the staged list.
> > 
> > The 20s timeout is a conservative upper bound and may be tightened
> > later. The timeout is purely defensive — the spec does not require it,
> > but prevents issues from a lost mailbox response or a crashed fabric manager.
> > 
> > The watchdog bounds how long a chain may stall, but a device could still
> > defeat it by streaming More=1 records faster than the timeout, growing the
> > staged list without bound. Also cap a runtime chain at
> > CXL_DC_MAX_PENDING_EXTENTS and refuse it once exceeded; existing-extent
> > recovery is bounded separately by the device's reported extent count.
> > 
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> Minor comment below in addition to sashiko
> 
[snip]

> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 4ffa7bd1e5f1..81498d47f309 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -8,6 +8,8 @@
> >  #include <linux/uuid.h>
> >  #include <linux/node.h>
> >  #include <linux/list.h>
> > +#include <linux/mutex.h>
> > +#include <linux/workqueue.h>
> >  #include <cxl/event.h>
> >  #include <cxl/mailbox.h>
> >  #include "cxl.h"
> > @@ -407,19 +409,33 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
> >  
> >  /**
> >   * struct pending_add_ctx - Staging state for an in-progress
> > - *			    DCD_ADD_CAPACITY event chain
> > + *							DCD_ADD_CAPACITY event chain
> >   * @pending_extents: extents received so far in the chain; flushed when
> > - *		     the chain closes (More=0)
> > + *					 the chain closes (More=0)
> >   * @group: tag group being assembled from the chain
> > + * @timeout_work: watchdog that fires if a chain is opened with
> > + *				  CXL_DCD_EVENT_MORE but the closing record never arrives
> > + * @lock: serialises updates to the chain state against the watchdog
> > + * @armed: set when a More=1 chain opens; cleared when the chain closes,
> > + *		   either by a More=0 event record or by the watchdog firing.
> >   *
> >   * A DCD_ADD_CAPACITY notification can span multiple event records
> >   * stitched together by the CXL_DCD_EVENT_MORE flag.  Records are staged
> > - * here until the device clears More, at which point the staged batch is
> > - * processed and responded to as a single Add_DC_Response.
> > + * here until an event record with 'More'=0 is received, at which point the
> > + * staged batch is processed and responded to as a single Add_DC_Response.
> > + *
> > + * If a chain is opened (More=1) but the device never sends the closing
> > + * record, the staged list would otherwise sit indefinitely.  @timeout_work
> > + * is a defensive watchdog that refuses such a chain with an empty response
> > + * and drops the staged list.
> >   */
> >  struct pending_add_ctx {
> >  	struct list_head pending_extents;
> >  	struct cxl_dc_tag_group *group;
> > +	struct delayed_work timeout_work;
> > +	struct mutex lock;
> > +	unsigned int nr_pending;
> 
> Missing kdoc in comment section
> 
Added

Thanks,
Anisa
> > +	bool armed;
> >  };
> >  
> >  /**
> 
