Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 023E4211ACED3
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 15:19:03 -0800 (PST)
Subject: ndctl v64 stage tree -- Re: [PATCH v7 00/12] ndctl: add security
 support
References: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <5b9f677a-2a6b-f999-ff3e-7a8ec8938868@oracle.com>
Date: Fri, 11 Jan 2019 15:18:59 -0800
MIME-Version: 1.0
In-Reply-To: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi, Dave,

Where is your ndctl git tree that might clone from to test the
security features?

Thanks!
-jane

On 1/9/2019 9:53 AM, Dave Jiang wrote:
> The following series implements mechanisms that utilize the sysfs knobs
> provided by the kernel in order to support the Intel DSM v1.8 spec
> that provides security to NVDIMM. The following abilities are added:
> 1. display security state
> 2. enable/update passphrase
> 3. disable passphrase
> 4. freeze security
> 5. secure erase
> 6. overwrite
> 7. master passphrase enable/update
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
