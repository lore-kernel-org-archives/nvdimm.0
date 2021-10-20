Received: from usmail.montage-tech.com (usmail.montage-tech.com [12.176.92.53])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7FD2C81
	for <nvdimm@lists.linux.dev>; Wed, 20 Oct 2021 07:33:40 +0000 (UTC)
X-MDAV-Result: clean
X-MDAV-Processed: usmail.montage-tech.com, Wed, 20 Oct 2021 00:33:34 -0700
Received: from shmail.montage-tech.com by usmail.montage-tech.com with ESMTP id md5001005847094.msg; 
	Wed, 20 Oct 2021 00:33:34 -0700
X-Spam-Processed: usmail.montage-tech.com, Wed, 20 Oct 2021 00:33:34 -0700
	(not processed: message from trusted or authenticated source)
X-MDArrival-Date: Wed, 20 Oct 2021 00:33:34 -0700
X-Return-Path: prvs=192785a790=johnny.li@montage-tech.com
X-Envelope-From: johnny.li@montage-tech.com
X-MDaemon-Deliver-To: nvdimm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=montage-tech.com;
	s=MDaemon; t=1634715185; x=1635319985;
	i=johnny.li@montage-tech.com; q=dns/txt; h=Date:From:To:Cc:
	Subject:Message-ID:References:MIME-Version:Content-Type:
	Content-Disposition:In-Reply-To:User-Agent; bh=m4ioVtaDhqFQgtQ/3
	kH2V+m020YxEfETxVfIYjFxw90=; b=KxaatfgVt2KlxrvGd7U2rHzEzaOZ5jmbQ
	/bblwz3zX/o1SPTwUhfoDRfNLLC3gDWmhk6H/GK/DnbRxwsBCmiFMRaIGXbmFHZ0
	+kAQtUTXJc9kBkbfYykbGHNj0fTpNldWAfrPvma+hPQ2w+dZM65F0kz1fCHmgovq
	yDQvy4miXI=
X-MDAV-Result: clean
X-MDAV-Processed: shmail.montage-tech.com, Wed, 20 Oct 2021 15:33:05 +0800
Received: from montage-desktop by shmail.montage-tech.com with ESMTPA id pp5001017671788.msg; 
	Wed, 20 Oct 2021 15:33:04 +0800
X-Spam-Processed: shmail.montage-tech.com, Wed, 20 Oct 2021 15:33:04 +0800
	(not processed: message from trusted or authenticated source)
Date: Wed, 20 Oct 2021 15:28:48 -0400
From: Li Qiang <johnny.li@montage-tech.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: can call libcxl function outside ndctl tool?
Message-ID: <20211020192848.GA12788@montage-desktop>
References: <20211019175518.GB47179@montage-desktop>
 <78e901122fa889e595e709d69a303446351540f4.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78e901122fa889e595e709d69a303446351540f4.camel@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-MDCFSigsAdded: montage-tech.com

On Wed, Oct 20, 2021 at 06:21:07AM +0000, Verma, Vishal L (vishal.l.verma@intel.com) wrote:
> On Tue, 2021-10-19 at 13:55 -0400, Li Qiang wrote:
> > Take cxl_cmd_new_identify as example.
> > There is CXL_EXPORT prefix, it seems can be called outside ndctl tool.
> 
> Yes it can be linked to like any other library.
Thanks for your confirmation

> 
> > While the intput and outpust struct cxl_memdev and cxl_cmd are private.
> > 
> > ```
> > 
> > CXL_EXPORT struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev)
> > {
> > 	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_IDENTIFY);
> > }
> > 
> > ```
> 
> Right - the intention is that those structs always remain private.
> Instead we provide accessor APIs to get fields out of the different
> command structures. e.g. for 'identify' we have
> cxl_cmd_identify_get_fw_rev, and so on. If there are other fields that
> lack these getter APIs, we can definitely add them. e.g. The
> health_info command has an exhaustive set of getter APIs.
These accessor getter APIs are used to decode output struct cxl_cmd.
Is there any setter APIs can construct the input struct cxl_memdev?

> 
> > 
> > 
> > Thanks
> > Johnny
> > 
> > 
> 


