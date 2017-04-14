Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E4182194EB5C
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 17:10:10 -0700 (PDT)
From: "Rudoff, Andy" <andy.rudoff@intel.com>
Subject: Re: [ndctl PATCH] ndctl, check: Add a sigbus handler to detect
 metadata corruption
Date: Fri, 14 Apr 2017 00:10:09 +0000
Message-ID: <F7CF62AA-B1F5-486D-AA87-F61674B86AC5@intel.com>
References: <20170414000251.23904-1-vishal.l.verma@intel.com>
In-Reply-To: <20170414000251.23904-1-vishal.l.verma@intel.com>
Content-Language: en-US
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


> If we have poison/badblocks in the BTT metadata sections, the mmap-reads
> happening in the checker will trigger a SIGBUS, and the program will
> halt abruptly. Add a sigbus handler which notifies the user of this, and
> prints out a relevant error message:
> 
>  namespace5.0: namespace_check: checking namespace5.0
>  namespace5.0: btt_discover_arenas: found 1 BTT arena
>  namespace5.0: btt_check_arenas: checking arena 0
>  namespace5.0: namespace_check: Received a SIGBUS
>  namespace5.0: namespace_check: Metadata corruption found, recovery is not possible
>  error checking namespaces: Bad address

If in repair mode, should a SIGBUS cause you to set the error state in the associated arena?

-andy

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
