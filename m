Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 365C1211B509F
 for <linux-nvdimm@lists.01.org>; Fri, 18 Jan 2019 15:33:35 -0800 (PST)
Subject: Re: [PATCH v9 13/13] ndctl: documentation for security and key
 management
References: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
 <154777917249.42557.10571100683446353177.stgit@djiang5-desk3.ch.intel.com>
 <d98a6c4168bcbd87ce69abd2421823af81686186.camel@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <58efe3a9-2504-dfc3-9a81-5cf122920c4e@intel.com>
Date: Fri, 18 Jan 2019 16:33:34 -0700
MIME-Version: 1.0
In-Reply-To: <d98a6c4168bcbd87ce69abd2421823af81686186.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 1/18/19 4:29 PM, Verma, Vishal L wrote:
> 
> On Thu, 2019-01-17 at 19:39 -0700, Dave Jiang wrote:
>> Add a "Theory of Operation" section describing the Intel DSM operations to
>> the relevant man pages.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  Documentation/ndctl/intel-nvdimm-security.txt   |  139 +++++++++++++++++++++++
>>  Documentation/ndctl/ndctl-freeze-security.txt   |    2 
>>  Documentation/ndctl/ndctl-remove-passphrase.txt |    2 
>>  Documentation/ndctl/ndctl-sanitize-dimm.txt     |    2 
>>  Documentation/ndctl/ndctl-setup-passphrase.txt  |    2 
>>  Documentation/ndctl/ndctl-update-passphrase.txt |    2 
> 
> Should this also be also be added to the new command,
> install-kek/install-encryption-key?

Yep. Good catch!

> 
>>  6 files changed, 149 insertions(+)
>>  create mode 100644 Documentation/ndctl/intel-nvdimm-security.txt
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
