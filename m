Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E3DD2098C211
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 15:03:43 -0700 (PDT)
Date: Thu, 31 May 2018 16:03:42 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [qemu PATCH v4 0/4] support NFIT platform capabilities
Message-ID: <20180531220342.GH28256@linux.intel.com>
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
 <20180525205051-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180525205051-mutt-send-email-mst@kernel.org>
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 25, 2018 at 08:51:22PM +0300, Michael S. Tsirkin wrote:
> On Mon, May 21, 2018 at 10:31:59AM -0600, Ross Zwisler wrote:
> > Changes since v3:
> >  * Updated the text in docs/nvdimm.txt to make it clear that the value
> >    being passed in on the command line in an integer made up of various
> >    bit fields. (Rob Elliott)
> >  
> >  * Updated the "Highest Valid Capability" byte to be dynamic based on
> >    the highest valid bit in the user's input. (Rob Elliott)
> 
> Igor could you review pls? I think your comments have been addressed.

Ping?  Igor, can you pick this up?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
