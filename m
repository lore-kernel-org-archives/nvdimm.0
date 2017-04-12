Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5DCB20D76485
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 17:24:27 -0700 (PDT)
Received: by mail-pg0-x243.google.com with SMTP id g2so2177310pge.2
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 17:24:27 -0700 (PDT)
Message-ID: <1491956661.8380.9.camel@gmail.com>
Subject: Re: [PATCH 5/9] powerpc/vmemmap: Add altmap support
From: Balbir Singh <bsingharora@gmail.com>
Date: Wed, 12 Apr 2017 10:24:21 +1000
In-Reply-To: <20170411174233.21902-6-oohall@gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
 <20170411174233.21902-6-oohall@gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc: arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2017-04-12 at 03:42 +1000, Oliver O'Halloran wrote:
> Adds support to powerpc for the altmap feature of ZONE_DEVICE memory. An
> altmap is a driver provided region that is used to provide the backing
> storage for the struct pages of ZONE_DEVICE memory. In situations where
> large amount of ZONE_DEVICE memory is being added to the system the
> altmap reduces pressure on main system memory by allowing the mm/
> metadata to be stored on the device itself rather in main memory.
> 
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---

Reviewed-by: Balbir Singh <bsingharora@gmail.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
