Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4370F21163248
 for <linux-nvdimm@lists.01.org>; Fri, 21 Dec 2018 09:08:29 -0800 (PST)
Subject: Re: linux-next: Tree for Dec 21 (nvdimm/security.o)
References: <20181221193244.3a6ed685@canb.auug.org.au>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8ae0ad4e-0c5c-a3dc-51b4-1616f459e45b@infradead.org>
Date: Fri, 21 Dec 2018 09:08:26 -0800
MIME-Version: 1.0
In-Reply-To: <20181221193244.3a6ed685@canb.auug.org.au>
Content-Language: en-US
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
To: Stephen Rothwell <sfr@canb.auug.org.au>, Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 12/21/18 12:32 AM, Stephen Rothwell wrote:
> Hi all,
> 
> News: there will be no linux-next release until Jan 2.  Have a good break.
> 
> Changes since 20181220:
> 

on x86_64:

ld: drivers/nvdimm/security.o: in function `nvdimm_request_key':
security.c:(.text+0xbe): undefined reference to `key_type_encrypted'
ld: drivers/nvdimm/security.o: in function `nvdimm_lookup_user_key.isra.1':
security.c:(.text+0x1ea): undefined reference to `key_type_encrypted'


Full randconfig file is attached.

-- 
~Randy
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
