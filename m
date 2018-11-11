Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
 [209.85.210.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D8D62117CE9E
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 13:24:24 -0800 (PST)
Received: by mail-pf1-f193.google.com with SMTP id v68-v6so3300260pfk.0
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 13:24:24 -0800 (PST)
Subject: Re: [driver-core PATCH v6 2/9] async: Add support for queueing on
 specific NUMA node
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170041079.12967.13132220574997822111.stgit@ahduyck-desk1.jf.intel.com>
 <20181111193208.GB8332@kroah.com> <20181111195903.GA9726@amd>
 <20181111203304.GA16871@kroah.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <7373f722-f498-f0fa-2eaf-8ac9200fb9e1@acm.org>
Date: Sun, 11 Nov 2018 13:24:21 -0800
MIME-Version: 1.0
In-Reply-To: <20181111203304.GA16871@kroah.com>
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
To: Greg KH <gregkh@linuxfoundation.org>, Pavel Machek <pavel@ucw.cz>
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, zwisler@kernel.org, tj@kernel.org, Alexander Duyck <alexander.h.duyck@linux.intel.com>, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 11/11/18 12:33 PM, Greg KH wrote:
> When I see new major patches show up from an Intel developer without
> _any_ other review from anyone else, directed at me, I get suspicious it
> is happening again.

Hi Greg,

Please note that I reviewed this patch four days ago. See also
https://lore.kernel.org/lkml/1541720197.196084.231.camel@acm.org/.

Thanks,

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
