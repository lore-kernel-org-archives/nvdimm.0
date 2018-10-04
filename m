Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 121F721148427
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 16:14:00 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] libndctl: set errno for routines that don't
 return an error status
Date: Thu, 4 Oct 2018 23:13:58 +0000
Message-ID: <47d409c7a41eac6edb2ba259f6cd395cc4d0d1b9.camel@intel.com>
References: <20181004223412.17403-1-vishal.l.verma@intel.com>
 <1dace9aed7cd223fc4e206e69b98b58c947fec17.camel@intel.com>
 <9bd7c5c4d9f389706bfcd13e9cd8b1632afbd6df.camel@intel.com>
 <34535e5c3a4d0d5f9b31933001127e7f18b77450.camel@intel.com>
In-Reply-To: <34535e5c3a4d0d5f9b31933001127e7f18b77450.camel@intel.com>
Content-Language: en-US
Content-ID: <65125E10AFDE5E41B7E537EF39ECB3CF@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-10-04 at 16:11 -0700, Williams, Dan J wrote:
> On Thu, 2018-10-04 at 16:01 -0700, Verma, Vishal L wrote:
> > On Thu, 2018-10-04 at 15:54 -0700, Williams, Dan J wrote:
> > > On Thu, 2018-10-04 at 16:34 -0600, Vishal Verma wrote:
> > > > For routines that return a UINT_MAX or UL{L}ONG_MAX, there isn't
> > > > a
> > > > way
> > > > to get any information as to what went wrong. Set errno in such
> > > > routines
> > > > so that the callers can get some additional context about the
> > > > error.
> > > 
> > > Looks ok, but why EOVERFLOW and not ENOMEM for the out of resource
> > > conditions?
> > 
> > I debated between that and also ENOSPC, but nothing seemed like an
> > exact fit for a buffer too small.. Mainly not ENOMEM because we
> > aren't
> > actually trying to allocate memory as a part of this?
> 
> That's true, but the effect is the same, couldn't get enough resource
> to complete the operation. I would expect EOVERFLOW for trying to store
> a 64-bit quantity in a 32-bit field.
> 

Good point, I'll change to ENOMEM.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
