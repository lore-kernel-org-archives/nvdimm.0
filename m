Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1CBD21A04E09
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 11:20:42 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170510180214.16852-4-hch@lst.de>
References: <20170510180214.16852-4-hch@lst.de>
 <20170510180214.16852-1-hch@lst.de>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
MIME-Version: 1.0
Content-ID: <2611.1494440436.1@warthog.procyon.org.uk>
Date: Wed, 10 May 2017 19:20:36 +0100
Message-ID: <2612.1494440436@warthog.procyon.org.uk>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Christoph Hellwig <hch@lst.de> wrote:

> -#define NULL_UUID_LE							\
> -	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
> -		0x00, 0x00, 0x00, 0x00)
> +#define NULL_GUID							\
> +	GUID(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
> +	     0x00, 0x00, 0x00, 0x00)
>  
> -#define NULL_UUID_BE							\
> -	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
> -		0x00, 0x00, 0x00, 0x00)
> +#define NULL_UUID							\
> +	UUID(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
> +	     0x00, 0x00, 0x00, 0x00)

These are UAPI and ought not to be renamed.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
