Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0238.hostedemail.com
 [216.40.44.238])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E5BE921A16EC1
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 00:13:02 -0700 (PDT)
Message-ID: <1495091565.31562.28.camel@perches.com>
Subject: Re: [PATCH 03/23] uuid: remove uuid_be defintions from the uapi header
From: Joe Perches <joe@perches.com>
Date: Thu, 18 May 2017 00:12:45 -0700
In-Reply-To: <20170518062705.25902-4-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-4-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> We don't use uuid_be and the UUID_BE constants in any uapi headers, so make
> them private to the kernel.

On the assumption that no user program uses them?
Is that a safe assumption?

> diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
> index 3738e5fb6a4d..0099756c4bac 100644
> --- a/include/uapi/linux/uuid.h
> +++ b/include/uapi/linux/uuid.h
> @@ -24,10 +24,6 @@ typedef struct {
>  	__u8 b[16];
>  } uuid_le;
>  
> -typedef struct {
> -	__u8 b[16];
> -} uuid_be;
> -
>  #define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
>  ((uuid_le)								\
>  {{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
> @@ -35,20 +31,8 @@ typedef struct {
>     (c) & 0xff, ((c) >> 8) & 0xff,					\
>     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
>  
> -#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
> -((uuid_be)								\
> -{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
> -   ((b) >> 8) & 0xff, (b) & 0xff,					\
> -   ((c) >> 8) & 0xff, (c) & 0xff,					\
> -   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
> -
>  #define NULL_UUID_LE							\
>  	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
>  		0x00, 0x00, 0x00, 0x00)
>  
> -#define NULL_UUID_BE							\
> -	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
> -		0x00, 0x00, 0x00, 0x00)
> -
> -
>  #endif /* _UAPI_LINUX_UUID_H_ */
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
