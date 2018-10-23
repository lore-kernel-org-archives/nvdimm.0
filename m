Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from merlin.infradead.org (merlin.infradead.org
 [IPv6:2001:8b0:10b:1231::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3CF982117D266
 for <linux-nvdimm@lists.01.org>; Mon, 22 Oct 2018 18:56:46 -0700 (PDT)
Subject: Re: [PATCH 2/9] dax: kernel memory driver for mm ownership of DAX
References: <20181022201317.8558C1D8@viggo.jf.intel.com>
 <20181022201320.45C9785C@viggo.jf.intel.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ddd650d6-6a0f-6c57-f55f-af31264c4f44@infradead.org>
Date: Mon, 22 Oct 2018 18:56:29 -0700
MIME-Version: 1.0
In-Reply-To: <20181022201320.45C9785C@viggo.jf.intel.com>
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
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, ying.huang@intel.com, linux-mm@kvack.org, zwisler@kernel.org, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On 10/22/18 1:13 PM, Dave Hansen wrote:
> Add the actual driver to which will own the DAX range.  This
> allows very nice party with the other possible "owners" of

Good to see a nice party sometimes.  :)

> a DAX region: device DAX and filesystem DAX.  It also greatly
> simplifies the process of handing off control of the memory
> between the different owners since it's just a matter of
> unbinding and rebinding the device to different drivers.


-- 
~Randy
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
