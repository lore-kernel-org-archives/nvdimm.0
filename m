Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C5942096966C
 for <linux-nvdimm@lists.01.org>; Fri, 18 May 2018 12:31:46 -0700 (PDT)
Date: Fri, 18 May 2018 13:31:45 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [qemu PATCH v2 3/4] nvdimm, acpi: support NFIT platform
 capabilities
Message-ID: <20180518193145.GA29547@linux.intel.com>
References: <20180517050024.20101-1-ross.zwisler@linux.intel.com>
 <20180517050024.20101-4-ross.zwisler@linux.intel.com>
 <AT5PR8401MB11697DD6A19AA3F499ACDDBAAB910@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <20180518152306.GA3413@linux.intel.com>
 <AT5PR8401MB11694A7F7825A488105AEFADAB900@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AT5PR8401MB11694A7F7825A488105AEFADAB900@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S . Tsirkin" <mst@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 18, 2018 at 04:37:10PM +0000, Elliott, Robert (Persistent Memory) wrote:
> 
> 
> ...
> > Would it help to show them in hex?
> > 
> >   As of ACPI 6.2 Errata A, the following values are valid for the bottom
> >   two bits:
> > 
> >   0x2 - Memory Controller Flush to NVDIMM Durability on Power Loss Capable.
> >   0x3 - CPU Cache Flush to NVDIMM Durability on Power Loss Capable.
> 
> Yes, that helps (unless the parser for that command-line does not 
> accept hex values).
> 
> It would also help to make the text be:
> 	"CPU Cache and Memory Controller Flush"

Yea, let me check on that.  I'll update the wording regardless to try and make
it more clear.

> ...
> > > So, there should be a way to specify a highest_cap value to convey that
> > > some of the upper capabilities bits are valid and contain 0.
> > 
> > Right, I'll make this dynamic based on the capabilities value passed in by
> > the user.  That's a much better solution, thanks.  This should cover all the
> > same cases as you have outlined above, without burdening the user with yet
> > another input value.
> 
> Automatically determining the highest bit that the user wants to set to 1
> should be easy, and will probably be the most common case.
> 
> It's harder to let the user set some upper bits to 0 but also have them
> within the highest_cap range.  Since this will be less common, the syntax
> could be more convoluted, like an optional highest_cap argument
> to override the automatically generated value.
> 
> For example, to report bits 7, 1 and 0 are all set to 1:
> 	-machine pc,accel=kvm,nvdimm,nvdimm-cap=0x83
> would automatically set highest_cap to 7.
> 
> To report bit 7 set to 0 while bits 1 and 0 are set to 1:
> 	-machine pc,accel=kvm,nvdimm,nvdimm-cap=0x3,nvdimm-highest-cap=7

Yea, I agree that this is how we could do it, but I don't think this is
necessary right now.  We currently only have 3 bits in the Capabilities field,
and right now there is never a case where there is a difference between "I
don't know about this bit" and "I know about this bit, and it's value is 0".

So, really for now we could essentially just say the highest_cap = 31 and be
fine.

Let's put off the nvdimm-highest-cap argument complexity until we actually
have a use case where it adds value.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
