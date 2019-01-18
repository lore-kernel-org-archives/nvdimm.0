Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22444211B63EF
 for <linux-nvdimm@lists.01.org>; Fri, 18 Jan 2019 13:12:11 -0800 (PST)
Subject: Re: [PATCH v9 02/13] ndctl: add command for ndctl to receive the key
 encryption key (master)
References: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
 <154777911312.42557.15688834797714631330.stgit@djiang5-desk3.ch.intel.com>
 <56a54d286cb2c7045478529e3ba34468fea3008f.camel@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <340b8cdd-bc30-73d2-627a-d3fcadc0c60a@intel.com>
Date: Fri, 18 Jan 2019 14:12:09 -0700
MIME-Version: 1.0
In-Reply-To: <56a54d286cb2c7045478529e3ba34468fea3008f.camel@intel.com>
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



On 1/18/19 1:58 PM, Verma, Vishal L wrote:
> 
> On Thu, 2019-01-17 at 19:38 -0700, Dave Jiang wrote:
>> Add command that allows the user to provide the master encryption key name
>> to be installed in the key material directory where ndctl can refer to
>> for later security operations.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  Documentation/ndctl/Makefile.am                   |    3 
>>  Documentation/ndctl/ndctl-install-encrypt-key.txt |   31 +++++
>>  configure.ac                                      |    3 
>>  ndctl/Makefile.am                                 |    4 -
>>  ndctl/builtin.h                                   |    1 
>>  ndctl/kek.c                                       |  133 +++++++++++++++++++++
>>  ndctl/lib/libndctl.c                              |   31 +++++
>>  ndctl/lib/libndctl.sym                            |    1 
>>  ndctl/lib/private.h                               |    1 
>>  ndctl/libndctl.h                                  |    1 
>>  ndctl/ndctl.c                                     |    1 
>>  11 files changed, 208 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/ndctl/ndctl-install-encrypt-key.txt
>>  create mode 100644 ndctl/kek.c
>>
>> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
>> index a30b139b..7cb7bd6b 100644
>> --- a/Documentation/ndctl/Makefile.am
>> +++ b/Documentation/ndctl/Makefile.am
>> @@ -47,7 +47,8 @@ man1_MANS = \
>>  	ndctl-inject-smart.1 \
>>  	ndctl-update-firmware.1 \
>>  	ndctl-list.1 \
>> -	ndctl-monitor.1
>> +	ndctl-monitor.1 \
>> +	ndctl-install-encrypt-key.1
> 
> I think Dan's feedback was to call this command setup-passphrase?
> By 'install-encrypt-key' it seems unclear whether you mean "install
> encrypted key" vs. "install a key and encrypt it"
> Alternatively, the command can simply be 'install-kek', and the
> synopsis/description can expand on what 'kek' is and how it is used.

It probably should be called install encrypted key or install encryption
key. The next patch has setup-passphrase. This isn't it.

> 
>>  
>>  CLEANFILES = $(man1_MANS)
>>  
>> diff --git a/Documentation/ndctl/ndctl-install-encrypt-key.txt b/Documentation/ndctl/ndctl-install-encrypt-key.txt
>> new file mode 100644
>> index 00000000..d00463e3
>> --- /dev/null
>> +++ b/Documentation/ndctl/ndctl-install-encrypt-key.txt
>> @@ -0,0 +1,31 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +ndctl-install-encrypt-key(1)
>> +============================
>> +
>> +NAME
>> +----
>> +ndctl-install-encrypt-key - store encryption key name for nvdimm bus
> 
> "store the encryption key handle for an nvdimm bus"
> 
>> +
>> +SYNOPSIS
>> +--------
>> +[verse]
>> +'ndctl install-encrypt-key <ndbus0> [<ndbus1>..<ndbusN>] [-k <master encryption key] [<options>]
>> +
>> +Take the provided master encryption key handle and store it in a file that
> 
> This sentence seems incomplete?
> 
>> +A file would be created for the designated bus provider.
>> +i.e. /etc/ndctl/keys/nfit_test.0.kek
> 
> With the makefile-vars-in-man-pages patch[1], all instances of hard
> coding this path in the documentation can now be converted to use the
> new scheme, and that should keep the man pages in sync with the actual
> build options.
> 
> [1]: https://patchwork.kernel.org/patch/10771507/
> 
> 
>> +The command only succeeds on bus(es) that contain nvdimms with security support.
> 
> This should be implied and is true for any command - the command will
> only work if the underlying feature is supported by the DIMM/platform,
> so I think we can omit this sentence.
> 
> I think you had a 'Description' section before, I think it is valuable
> to retain it and add a blurb about the keyctl steps that might be
> needed before invoking this command.
>> +
>> +OPTIONS
>> +-------
>> +-k::
>> +--kek=::
>> +	Key encryption key (master key) handle. The key handle has the format
>> +	of <key type>:<key name>. i.e. trusted:nvdimm-master.
>> +
>> +-v::
>> +--verbose::
>> +	Turn on debug output
>> +
>> +include::../copyright.txt[]
>>
>>
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
