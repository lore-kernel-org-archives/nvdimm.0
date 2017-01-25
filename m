Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0220.hostedemail.com
 [216.40.44.220])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2467B81F07
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 18:37:26 -0800 (PST)
Message-ID: <1485311842.12563.50.camel@perches.com>
Subject: Re: [PATCH] nvdimm: constify device_type structures
From: Joe Perches <joe@perches.com>
Date: Tue, 24 Jan 2017 18:37:22 -0800
In-Reply-To: <1485285847-7006-1-git-send-email-bhumirks@gmail.com>
References: <1485285847-7006-1-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
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
To: Bhumika Goyal <bhumirks@gmail.com>, julia.lawall@lip6.fr, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2017-01-25 at 00:54 +0530, Bhumika Goyal wrote:
> Declare device_type structure as const as it is only stored in the
> type field of a device structure. This field is of type const, so add
> const to declaration of device_type structure.
> 
> File size before:
>   text	   data	    bss	    dec	    hex	filename
>   19278	   3199	     16	  22493	   57dd	nvdimm/namespace_devs.o
> 
> File size after:
>   text	   data	    bss	    dec	    hex	filename
>   19929	   3160	     16	  23105	   5a41	nvdimm/namespace_devs.o

Fine, but are you sure about the sizes?

It seems odd the text went up 651 bytes
while the data went down just 39 bytes.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
