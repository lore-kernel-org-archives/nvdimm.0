Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D61817E6
	for <nvdimm@lists.linux.dev>; Fri, 15 Apr 2022 07:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TY7QrgqvgkH5i76LkYOioJ0Vkl4t7pW84wpQ7D92y58=; b=AcTLpeAaH8w+tdpl/NmhorrElG
	atvXYjPxEjQikC6x8SE+8HDVNTKWoEM+FsvUcvG076jAx7xNIBIvcqgiwE0V3stZBhNYOXvvA8vnZ
	zc4gx12b/A49yO4WhN6hQsKF84PF1ZIKeDYCKEyTke1hgE7VU8FSAQ7J9g203MaXF6QO8AGljarVP
	CiPXaijMzIGIDUDOW4kMw/7ezQFealbxmBG93M5cbBcYs9iGkeAWRYzU3JLVT2kx8bAwbi1fzS0Tr
	4+8w56oKLwIqD+IPKGefsfHR8DOgu51TXQliqANImjXt/+Xm+usnuab0TgQGxZ+xFgwj5I68klTUD
	SZQ9CvVg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nfGm5-00Fwly-Ay; Fri, 15 Apr 2022 07:53:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E02683001AE;
	Fri, 15 Apr 2022 09:53:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9D2DF2025D913; Fri, 15 Apr 2022 09:53:48 +0200 (CEST)
Date: Fri, 15 Apr 2022 09:53:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v2 02/12] device-core: Add dev->lock_class to enable
 device_lock() lockdep validation
Message-ID: <YlkkjLJg4a+2gqiq@hirez.programming.kicks-ass.net>
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164982969858.684294.17819743973041389492.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220413084309.GV2731@worktop.programming.kicks-ass.net>
 <CAPcyv4huZVNkxa7-rQ_J=nVN77+5F1AJg5vi6kLHp8t5khcwHA@mail.gmail.com>
 <Ylf0dewci8myLvoW@hirez.programming.kicks-ass.net>
 <CAPcyv4hFabn6H064HTrH8=GQ-cxsOk4xEK8s66JQxQavfgAzGw@mail.gmail.com>
 <Ylh3ISDToV5y9/4P@hirez.programming.kicks-ass.net>
 <CAPcyv4hwsKCbaxDhAL6LPZQmLZZV2T4wpja+cNZpjy=enR-eYQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hwsKCbaxDhAL6LPZQmLZZV2T4wpja+cNZpjy=enR-eYQ@mail.gmail.com>

On Thu, Apr 14, 2022 at 12:43:31PM -0700, Dan Williams wrote:
> On Thu, Apr 14, 2022 at 12:34 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Thu, Apr 14, 2022 at 10:17:13AM -0700, Dan Williams wrote:
> >
> > > One more sanity check... So in driver subsystems there are cases where
> > > a device on busA hosts a topology on busB. When that happens there's a
> > > need to set the lock class late in a driver since busA knows nothing
> > > about the locking rules of busB.
> >
> > I'll pretend I konw what you're talking about ;-)
> >
> > > Since the device has a longer lifetime than a driver when the driver
> > > exits it must set dev->mutex back to the novalidate class, otherwise
> > > it sets up a use after free of the static lock_class_key.
> >
> > I'm not following, static storage has infinite lifetime.
> 
> Not static storage in a driver module.
> 
> modprobe -r fancy_lockdep_using_driver.ko
> 
> Any use of device_lock() by the core on a device that a driver in this
> module was driving will de-reference a now invalid pointer into
> whatever memory was vmalloc'd for the module static data.

Ooh, modules (I always, conveniently, forget they exist). Yes, setting a
lock instance from the core kernel to a key that's inside a module and
then taking the module out will be 'interesting'.

Most likely you'll get a splat from lockdep when doing this.
