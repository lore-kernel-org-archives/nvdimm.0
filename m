Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39715203B9921
 for <linux-nvdimm@lists.01.org>; Mon, 21 May 2018 08:54:50 -0700 (PDT)
Date: Mon, 21 May 2018 09:54:49 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [qemu PATCH v2 3/4] nvdimm, acpi: support NFIT platform
 capabilities
Message-ID: <20180521155449.GA22635@linux.intel.com>
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

Yep, the command-line parser does accept hex values.  I ended up just trying
to make the text clearer, though.

> It would also help to make the text be:
> 	"CPU Cache and Memory Controller Flush"

My descriptions for the bits are coming straight out of ACPI. :)  I'd prefer
to stay consistent with what's written in the spec.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
