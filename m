Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3CBBD81D36
 for <linux-nvdimm@lists.01.org>; Mon, 28 Nov 2016 13:26:36 -0800 (PST)
Date: Mon, 28 Nov 2016 14:26:26 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/1] libnvdimm, namespace: fix the type of name variable
Message-ID: <20161128212626.GB16225@linux.intel.com>
References: <20161126191804.21349-1-nicolas.iooss_linux@m4x.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161126191804.21349-1-nicolas.iooss_linux@m4x.org>
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
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Nov 26, 2016 at 08:18:04PM +0100, Nicolas Iooss wrote:
> In create_namespace_blk(), the local variable "name" is defined as an
> array of NSLABEL_NAME_LEN pointers:
> 
>     char *name[NSLABEL_NAME_LEN];
> 
> This variable is then used in calls to memcpy() and kmemdup() as if it
> were char[NSLABEL_NAME_LEN]. Remove the star in the variable definition
> to makes it look right.
> 
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Yep, nice catch.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
