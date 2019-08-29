Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4752C20218C5B
 for <linux-nvdimm@lists.01.org>; Thu, 29 Aug 2019 11:10:01 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 3/3] ndctl/namespace: add a --continue option to
 create namespaces greedily
Date: Thu, 29 Aug 2019 18:08:07 +0000
Message-ID: <e343ace46d7243632eec594f679759fac78814ba.camel@intel.com>
References: <20190829001735.30289-1-vishal.l.verma@intel.com>
 <20190829001735.30289-4-vishal.l.verma@intel.com>
 <179261bd-9812-6bba-6710-19a77cf3acc6@oracle.com>
In-Reply-To: <179261bd-9812-6bba-6710-19a77cf3acc6@oracle.com>
Content-Language: en-US
Content-ID: <7589F471D9602B44A2BE10FB912FA08D@intel.com>
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
To: "jane.chu@oracle.com" <jane.chu@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "Scargall, Steve" <steve.scargall@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2019-08-29 at 10:38 -0700, jane.chu@oracle.com wrote:
> Hi, Vishal,
> 
> 
> On 8/28/19 5:17 PM, Vishal Verma wrote:
> > Add a --continue option to ndctl-create-namespaces to allow the creation
> > of as many namespaces as possible, that meet the given filter
> > restrictions.
> > 
> > The creation loop will be aborted if a failure is encountered at any
> > point.
> 
> Just wondering what is the motivation behind providing this option?

Hi Jane,

See Steve's email here:
https://lists.01.org/pipermail/linux-nvdimm/2019-August/023390.html

Essentially it lets sysadmins create a simple, maximal configuration
without everyone having to script it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
