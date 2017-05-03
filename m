Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C86E21A04830
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 17:11:46 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v5] ndctl: add clear error support for ndctl
Date: Wed, 3 May 2017 00:11:44 +0000
Message-ID: <1493770222.20330.0.camel@intel.com>
References: <149375673867.14088.8455971000052942105.stgit@djiang5-desk3.ch.intel.com>
 <20170502235424.GB11414@omniknight.lm.intel.com>
 <252297ca-d163-2f53-f97f-a792725b05b6@intel.com>
In-Reply-To: <252297ca-d163-2f53-f97f-a792725b05b6@intel.com>
Content-Language: en-US
Content-ID: <0A109E45B87D724CB3A21515ADE052FB@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2017-05-02 at 17:08 -0700, Dave Jiang wrote:
> On 05/02/2017 04:54 PM, Vishal Verma wrote:
> > On 05/02, Dave Jiang wrote:
> > > 
> > > +
> > > +	if (!S_ISCHR(stats.st_mode)) {
> > > +		error("%s not DAX device\n", dev_name);
> > > +		return -1;
> > > +	}
> > > +
> > 
> > A more general question, we're restricting the clear-error command
> > to
> > dax devs, but is there any reason to do that? Why not just allow
> > clearing errors for normal namespaces too using this?
> 
> The thinking was to get the dax devs support in initially and then add
> everything else in the next iteration.
> 

Ah ok, that's fine.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
