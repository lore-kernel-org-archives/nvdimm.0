Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BFFDD21194885
 for <linux-nvdimm@lists.01.org>; Thu, 22 Nov 2018 17:23:38 -0800 (PST)
Subject: Re: [driver-core PATCH v5 5/9] driver core: Establish clear order of
 operations for deferred probe and remove
References: <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
 <201811061228.iteFLO2p%fengguang.wu@intel.com>
 <1541548274.196084.197.camel@acm.org>
From: Rong Chen <rong.a.chen@intel.com>
Message-ID: <d70f2bcb-0e1c-2d69-2692-329ef5cf81bc@intel.com>
Date: Fri, 23 Nov 2018 09:23:47 +0800
MIME-Version: 1.0
In-Reply-To: <1541548274.196084.197.camel@acm.org>
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
To: Bart Van Assche <bvanassche@acm.org>, kbuild test robot <lkp@intel.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: len.brown@intel.com, linux-nvdimm@lists.01.org, gregkh@linuxfoundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, kbuild-all@01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 11/07/2018 07:51 AM, Bart Van Assche wrote:
> On Tue, 2018-11-06 at 12:10 +0800, kbuild test robot wrote:
>> Hi Alexander,
>>
>> Thank you for the patch! Perhaps something to improve:
>>
>> [auto build test WARNING on driver-core/master]
>>
>> url:    https://github.com/0day-ci/linux/commits/Alexander-Duyck/Add-NUMA-aware-async_schedule-calls/20181106-093800
>> reproduce: make htmldocs
>>
>> All warnings (new ones prefixed by >>):
>>
>>     include/net/mac80211.h:1001: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
>> [ ... ]
> There are plenty of references in this report to header files not touched
> by patch 5/9 in this series. I assume that this report indicates a bug in
> the 0-day testing infrastructure?
>
> Bart.
>
Hi Bart,

Kbuild robot printed all warnings and the below warning was found in 
patch 5/9.

"include/linux/device.h:1056: warning: Function parameter or member 
'async_probe' not described in 'device'"

Best Regards,
Rong Chen
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
