Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CEB4B21BB253A
 for <linux-nvdimm@lists.01.org>; Mon, 12 Jun 2017 13:17:47 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] libnvdimm, pmem: Add sysfs notifications to badblocks
Date: Mon, 12 Jun 2017 20:18:33 +0000
Message-ID: <1497298683.9288.14.camel@hpe.com>
References: <20170612164206.5794-1-toshi.kani@hpe.com>
In-Reply-To: <20170612164206.5794-1-toshi.kani@hpe.com>
Content-Language: en-US
Content-ID: <1FA8DD5320B3B64C939B0C97E1C8AE0A@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2017-06-12 at 10:42 -0600, Toshi Kani wrote:
> Sysfs "badblocks" information may be updated during run-time via
> MCE, SCI, and sysfs "scrub".
> 
> Add support to send sysfs notifications to sysfs "badblocks" file
> under region and pmem directories when their badblocks information
> is re-evaluated (but is not necessarily changed) during run-time.

Thinking further, this notification should be sent when a badblock is
cleared via _DSM.  I will update and send v2.

-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
