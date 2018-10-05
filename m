Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F6CC21161B0E
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 17:06:20 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH 1/2] ndctl, monitor: fix the severity of the
 "daemon started" message
Date: Fri, 5 Oct 2018 00:04:45 +0000
Message-ID: <6ffae940b64e1bae2b86c76152cfbf9e16109ec2.camel@intel.com>
References: <20181005000057.30186-1-vishal.l.verma@intel.com>
In-Reply-To: <20181005000057.30186-1-vishal.l.verma@intel.com>
Content-Language: en-US
Content-ID: <9827665D7EF2A14B87F658117DDFDD31@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "andreas@canonical.com" <andreas@canonical.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-10-04 at 18:00 -0600, Vishal Verma wrote:
> The above message was printed as an error, but it is just an
> informational message. Change it to dbg().
> 
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
