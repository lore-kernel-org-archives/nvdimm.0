Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 141AD21A143EF
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 15:33:55 -0700 (PDT)
Date: Tue, 26 Jun 2018 16:37:03 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [ndctl PATCH 1/2] ndctl: Add 'list' verbose options
Message-ID: <20180626223702.GA7824@localhost.localdomain>
References: <20180626204649.7665-1-keith.busch@intel.com>
 <CAPcyv4gaGsufzXc9KNaTnrHJU+Mf+eQtFW=7ENmMdGNh9LNK4A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gaGsufzXc9KNaTnrHJU+Mf+eQtFW=7ENmMdGNh9LNK4A@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 26, 2018 at 02:11:30PM -0700, Dan Williams wrote:
> This turns on listing DIMMs even if --dimms was not specified on the
> command line. I was thinking not until level 2 do we start turning on
> more device objects beyond what is specified. For example "ndctl list
> -v" is the same as "ndctl list" that lists namespaces by default.
> However it goes further to turn on extra / namespace-relative data
> like 'raw_uuid' and 'sector_size' but also data like "--media-errors"
> and "--dax". Then it follows commands like "ndctl list -Dv" list the
> DIMMs and turns on optional fields like 'handle' and 'phys_id' in
> addition to "--health" information.

Aha, that makes more sense. Thanks for the info.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
