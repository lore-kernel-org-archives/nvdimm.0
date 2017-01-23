Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC9FB81EDE
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 09:43:09 -0800 (PST)
Date: Mon, 23 Jan 2017 10:42:57 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] ndctl: add a BTT check utility
Message-ID: <20170123174257.GA19362@linux.intel.com>
References: <20170120031234.24226-1-vishal.l.verma@intel.com>
 <CAPcyv4gU5ujYJt0PLbNb4t64vRCnXhBxhfdB9ineZmgdAys2vg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gU5ujYJt0PLbNb4t64vRCnXhBxhfdB9ineZmgdAys2vg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 20, 2017 at 12:04:46PM -0800, Dan Williams wrote:
> [ adding Jeff ]
> 
> Some comments on boilerplate / organization items...
> 
> 
> On Thu, Jan 19, 2017 at 7:12 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> > Add the check-namespace command to ndctl. This will check the BTT
> > metadata layout for the given namespace, and if requested, correct any
> > errors found. Not all metadata corruption is detectable or fixable.
> >
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
<>
> > +static int btt_read_info(struct btt_chk *bttc, struct btt_sb *btt_sb, __u64 off)
> > +{
> > +       int fd, rc = 0;
> > +       ssize_t size;
> > +
> > +       fd = open(bttc->path, O_RDONLY);
> 
> Let's not open and close the btt device on each call. Open it once at
> the beginning of time and open it O_EXCL so that we prevent the kernel
> trying to claim the device. Let's also use O_DIRECT to bypass the
> block_device page cache.

I thought O_EXCL only mattered if it was used for creation of new files with
O_CREAT?

https://linux.die.net/man/3/open

For us bttc->path is our device in /dev/, so that O_EXCL shouldn't do anything
for us?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
