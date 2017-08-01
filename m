Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C0D0209589D3
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 13:04:35 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4 0/6] BTT error clearing rework
Date: Tue, 1 Aug 2017 20:06:08 +0000
Message-ID: <1501617398.2042.102.camel@hpe.com>
References: <20170726233546.29052-1-vishal.l.verma@intel.com>
 <1501542358.2042.97.camel@hpe.com> <1501544000.4405.5.camel@intel.com>
 <1501600767.2042.99.camel@hpe.com> <1501614143.2042.101.camel@hpe.com>
 <20170801195630.GC18006@omniknight.lm.intel.com>
In-Reply-To: <20170801195630.GC18006@omniknight.lm.intel.com>
Content-Language: en-US
Content-ID: <9E0D22050EBD1C4B8CC120DB9B322BBF@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2017-08-01 at 13:56 -0600, Vishal Verma wrote:
 :
> 
> Hey Toshi, that is a great catch (I'm going to look at enhancing the
> unit tests too to catch this).
> 
> Your patch is correct. Normally whenever we calculate a 'nsoff', we
> use that to do arena_{read,write}_bytes, and that takes care of
> adding the initial_offset. This was the first instance where we
> calculated nsoff and did something other than rw_bytes with it (i.e.
> is_bad_pmem), and therefore this nsoff needs the initial_offset
> adjustment manually..
> 
> However just adding that here is inviting future bugs like this, so
> I'm going to refactor the initial_offset adjustment into some helpers
> and use those across the board. That should prevent this sort of a
> bug again.

Sounds great.  Thanks Vishal!
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
