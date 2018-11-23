Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com
 [209.85.214.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8AD93211935A4
 for <linux-nvdimm@lists.01.org>; Fri, 23 Nov 2018 06:19:56 -0800 (PST)
Received: by mail-pl1-f196.google.com with SMTP id z23so10727808plo.0
 for <linux-nvdimm@lists.01.org>; Fri, 23 Nov 2018 06:19:56 -0800 (PST)
Subject: Re: [driver-core PATCH v5 5/9] driver core: Establish clear order of
 operations for deferred probe and remove
References: <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
 <201811061228.iteFLO2p%fengguang.wu@intel.com>
 <1541548274.196084.197.camel@acm.org>
 <d70f2bcb-0e1c-2d69-2692-329ef5cf81bc@intel.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <f9ccdf33-6b7a-cdb2-150b-3ab83892c96e@acm.org>
Date: Fri, 23 Nov 2018 06:19:53 -0800
MIME-Version: 1.0
In-Reply-To: <d70f2bcb-0e1c-2d69-2692-329ef5cf81bc@intel.com>
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
To: Rong Chen <rong.a.chen@intel.com>, kbuild test robot <lkp@intel.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: len.brown@intel.com, linux-nvdimm@lists.01.org, gregkh@linuxfoundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, kbuild-all@01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 11/22/18 5:23 PM, Rong Chen wrote:
> Kbuild robot printed all warnings and the below warning was found in 
> patch 5/9.
> 
> "include/linux/device.h:1056: warning: Function parameter or member 
> 'async_probe' not described in 'device'"

Hi Rong,

Thanks for having taken a look. That's indeed something that must be 
fixed in patch 5/9.

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
