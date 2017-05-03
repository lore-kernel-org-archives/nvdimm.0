Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B472B2195DA40
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 17:08:53 -0700 (PDT)
Subject: Re: [PATCH v5] ndctl: add clear error support for ndctl
References: <149375673867.14088.8455971000052942105.stgit@djiang5-desk3.ch.intel.com>
 <20170502235424.GB11414@omniknight.lm.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <252297ca-d163-2f53-f97f-a792725b05b6@intel.com>
Date: Tue, 2 May 2017 17:08:52 -0700
MIME-Version: 1.0
In-Reply-To: <20170502235424.GB11414@omniknight.lm.intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 05/02/2017 04:54 PM, Vishal Verma wrote:
> On 05/02, Dave Jiang wrote:
>> Adding ndctl support that will allow clearing of bad blocks for a device.
>> Initial implementation will only support device dax devices. The ndctl
>> takes a device path and parameters of the starting bad block, and the number
>> of bad blocks to clear.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>
>> v2: Addressed comments from Vishal
>> - added bounds checking for the badblocks region.
>> - updated verbiage to use badblocks instead of poison.
>> - set default len to 1.
>> - fixed error out for stat
>> - fixed error out that was copy/paste error
>> - remove duplicate check_min_kver() in shell script
>> - fixed logic of checking empty badblocks
>>
>> v3: Addressed comments from Toshi
>> - Fixed bad region path for badblocks
>>
>> v4: Address comments from Toshi
>> - Added error output for length that exceeds badblock coverage.
>>
>> v5: Address comments from Toshi
>> - Made -l 0 to error out and no length means 1 block cleared.
>>
>>  Documentation/Makefile.am           |    1 
>>  Documentation/ndctl-clear-error.txt |   40 ++++++
>>  builtin.h                           |    1 
>>  ndctl/Makefile.am                   |    1 
>>  ndctl/clear-error.c                 |  241 +++++++++++++++++++++++++++++++++++
>>  ndctl/lib/libndctl.c                |   70 ++++++++++
>>  ndctl/lib/libndctl.sym              |    2 
>>  ndctl/libndctl.h.in                 |   10 +
>>  ndctl/ndctl.c                       |    4 -
>>  test/Makefile.am                    |    1 
>>  test/ndctl-clear-error-dax.sh       |   68 ++++++++++
>>  11 files changed, 438 insertions(+), 1 deletion(-)
>>  create mode 100644 Documentation/ndctl-clear-error.txt
>>  create mode 100644 ndctl/clear-error.c
>>  create mode 100755 test/ndctl-clear-error-dax.sh
>>

<snip>

>> +
>> +static int clear_error(struct clear_err *ce)
>> +{
>> +	struct stat stats;
>> +	int rc;
>> +	char dev_name[256];
>> +	uint64_t base;
>> +	unsigned long long start;
>> +	unsigned int len;
>> +
>> +	strncpy(dev_name, ce->dev_name, 256);
>> +
>> +	rc = stat(dev_name, &stats);
>> +	if (rc < 0) {
>> +		perror("stat failed");
>> +		error("Unable to stat %s\n", dev_name);
>> +		return -1;
>> +	}
>> +
>> +	if (!S_ISCHR(stats.st_mode)) {
>> +		error("%s not DAX device\n", dev_name);
>> +		return -1;
>> +	}
>> +
> 
> A more general question, we're restricting the clear-error command to
> dax devs, but is there any reason to do that? Why not just allow
> clearing errors for normal namespaces too using this?

The thinking was to get the dax devs support in initially and then add
everything else in the next iteration.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
