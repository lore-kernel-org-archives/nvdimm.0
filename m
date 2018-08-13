Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C06820945C0A
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 07:29:02 -0700 (PDT)
Date: Mon, 13 Aug 2018 08:29:42 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [ndctl PATCH 1/2] ndctl: fix potential null dereference in the
 smart error handler
Message-ID: <20180813142941.GA32027@localhost.localdomain>
References: <20180811004053.15392-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180811004053.15392-1-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 10, 2018 at 06:40:52PM -0600, Vishal Verma wrote:
> Static analysis reports that can potentially dereference a NULL pointer
> in the smart cmd error handler. This can particular instance won't ever
> be hit in practice as the handler is only registered for smart commands,
> and smart commands are currently only DIMM commands, and will always
> have a dimm object. However for completeness, and to avoid future
> errors, we should perform a NULL check in the handler anyway.

Hmm, I purposefully didn't have the NULL check because the dimm is never
not set in this path. Looks like a false positive, but the NULL check is
harmless.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
