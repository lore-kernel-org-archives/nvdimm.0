Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0658B2116DA2F
 for <linux-nvdimm@lists.01.org>; Mon, 12 Nov 2018 12:13:40 -0800 (PST)
Subject: Re: [PATCH 02/11] libnvdimm/security: change clear text nvdimm keys
 to encrypted keys
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180163666.70506.8805433934495072699.stgit@djiang5-desk3.ch.intel.com>
 <1541957268.3734.53.camel@linux.ibm.com>
 <CAPcyv4jMPDap8L6jTo9NGnrJGCjUY_BvSBuPge8NL4QS2Ku0CQ@mail.gmail.com>
 <1541966975.3734.78.camel@linux.ibm.com>
 <bf917ee9-1795-9c10-ecec-28c7d5d68345@intel.com>
 <1542048586.3769.120.camel@linux.ibm.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <fcc0b162-df9d-6abc-a2e7-f76a75a383b3@intel.com>
Date: Mon, 12 Nov 2018 13:13:37 -0700
MIME-Version: 1.0
In-Reply-To: <1542048586.3769.120.camel@linux.ibm.com>
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
To: Mimi Zohar <zohar@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>
Cc: keyrings@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 11/12/18 11:49 AM, Mimi Zohar wrote:
> On Mon, 2018-11-12 at 08:42 -0700, Dave Jiang wrote:
> 
>> How does one generate new encrypted keys with the system masterkey 
>> removed from the keyring?
> 
> I don't think you can.

Are there any documentations available showing system master-key usages?
So far the docs (i.e. EVM setup) I've seen generates a trusted master
key and then create the encrypted keys from that. I'm missing the
understanding of how to generate encrypted keys from the system master
key initially during setup. Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
