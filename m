Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3392822685253
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 15:06:05 -0700 (PDT)
Received: from G9W8455.americas.hpqcorp.net (g9w8455.houston.hp.com
 [16.216.161.94])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2353.austin.hpe.com (Postfix) with ESMTPS id 4F29E8D
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 22:06:04 +0000 (UTC)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [ndctl PATCH v2 2/3] nfit, address-range-scrub: rework and
 simplify ARS state machine
Date: Fri, 6 Apr 2018 22:06:02 +0000
Message-ID: <1523052334.2693.330.camel@hpe.com>
References: <152298833162.13386.16059994933936258291.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152298834229.13386.9535080244838507823.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152298834229.13386.9535080244838507823.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <62309A6861301C42AF05E51B0E669592@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-04-05 at 21:19 -0700, Dan Williams wrote:
> ARS is an operation that can take 10s to 100s of seconds to find media
> errors that should rarely be present. If the platform crashes due to
> media errors in persistent memory, the expectation is that the BIOS will
> report those known errors in a 'short' ARS request.
> 
> A 'short' ARS request asks platform firmware to return an ARS payload
> with all known errors, but without issuing a 'long' scrub. At driver
> init a short request is issued to all PMEM ranges before registering
> regions. Then, in the background, a long ARS is scheduled for each
> region.

I confirmed that this version addressed the WARN_ONCE issue.

> The ARS implementation is simplified to centralize ARS completion work
> in the ars_complete() helper called from ars_status_process_records().
> The timeout is removed since there is no facility to cancel ARS, and
> system init is never blocked waiting for a 'long' ARS. The ars_state
> flags are used to coordinate ARS requests from driver init, ARS requests
> from userspace, and ARS requests in response to media error
> notifications.

While I like the simplification of the code, I leaned that we need to
handle both cases below:
 
 1) No FW ARS Scan: ARS short scan and enable pmem devices without delay
(new behavior by this patch)
 2) FW ARS Scan: Wait for FW ARS scan to complete, and then enable pmem
devices

Case 2) is still necessary because:

 - After a system crash in certain error scenario, FW may not be able to
obtain all error records and need ARS long scan to retrieve them.
 - Other OSes do not initiate an ARS long scan, and assume FW to start
it at POST when necessary.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
