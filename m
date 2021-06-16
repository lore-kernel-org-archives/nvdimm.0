Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6846570
	for <nvdimm@lists.linux.dev>; Wed, 16 Jun 2021 01:31:33 +0000 (UTC)
IronPort-SDR: 1xb/EJpeM2oxS9k8ZiK6MYav59UQrxDJ9cj3zMFxt1EtZZGtaHLrdXUXaHym9Mz0QemOwLPyxs
 ggYuhcS6rRUw==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="193407604"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="193407604"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 18:31:32 -0700
IronPort-SDR: 6HqcgPeRMbFXyIL3j6lCvFr3g/fe96bgH8OHJiqhNfxsWeTXbEZQRjQcOF7gQTcS8YqEOMUlFL
 wh6OS8AdIfHA==
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="421316463"
Received: from jingqili-mobl.ccr.corp.intel.com (HELO [10.238.4.189]) ([10.238.4.189])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 18:31:31 -0700
Subject: Re: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
To: "Williams, Dan J" <dan.j.williams@intel.com>
References: <20210609030642.66204-1-jingqi.liu@intel.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
From: "Liu, Jingqi" <jingqi.liu@intel.com>
Message-ID: <9b92ffef-c01d-05fc-3cf6-2f7565b5fb69@intel.com>
Date: Wed, 16 Jun 2021 09:31:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210609030642.66204-1-jingqi.liu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dan,

This is the second version of the patch.
Any comments?

Thanks,
Jingqi

On 6/9/2021 11:06 AM, Liu, Jingqi wrote:
> The following bug is caused by setting the size of Label Index Block
> to a fixed 256 bytes.
> 
> Use the following Qemu command to start a Guest with 2MB label-size:
> 	-object memory-backend-file,id=mem1,share=on,mem-path=/dev/dax1.1,size=14G,align=2M
> 	-device nvdimm,memdev=mem1,id=nv1,label-size=2M
> 
> There is a namespace in the Guest as follows:
> 	$ ndctl list
> 	[
> 	  {
> 	    "dev":"namespace0.0",
> 	    "mode":"devdax",
> 	    "map":"dev",
> 	    "size":14780727296,
> 	    "uuid":"58ad5282-5a16-404f-b8ee-e28b4c784eb8",
> 	    "chardev":"dax0.0",
> 	    "align":2097152,
> 	    "name":"namespace0.0"
> 	  }
> 	]
> 
> Fail to read labels. The result is as follows:
> 	$ ndctl read-labels -u nmem0
> 	[
> 	]
> 	read 0 nmem
> 
> If using the following Qemu command to start the Guest with 128K
> label-size, this label can be read correctly.
> 	-object memory-backend-file,id=mem1,share=on,mem-path=/dev/dax1.1,size=14G,align=2M
> 	-device nvdimm,memdev=mem1,id=nv1,label-size=128K
> 
> The size of a Label Index Block depends on how many label slots fit into
> the label storage area. The minimum size of an index block is 256 bytes
> and the size must be a multiple of 256 bytes. For a storage area of 128KB,
> the corresponding Label Index Block size is 256 bytes. But if the label
> storage area is not 128KB, the Label Index Block size should not be 256 bytes.
> 
> Namespace Label Index Block appears twice at the top of the label storage area.
> Following the two index blocks, an array for storing labels takes up the
> remainder of the label storage area.
> 
> For obtaining the size of Namespace Index Block, we also cannot rely on
> the field of 'mysize' in this index block since it might be corrupted.
> Similar to the linux kernel, we use sizeof_namespace_index() to get the size
> of Namespace Index Block. Then we can also correctly calculate the starting
> offset of the following namespace labels.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
> ---
>   ndctl/dimm.c           | 19 +++++++++++++++----
>   ndctl/lib/dimm.c       |  5 +++++
>   ndctl/lib/libndctl.sym |  1 +
>   ndctl/libndctl.h       |  1 +
>   4 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index 09ce49e..1d2d9a2 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -94,13 +94,18 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
>   	struct json_object *jarray = json_object_new_array();
>   	struct json_object *jlabel = NULL;
>   	struct namespace_label nslabel;
> +	unsigned int nsindex_size;
>   	unsigned int slot = -1;
>   	ssize_t offset;
>   
>   	if (!jarray)
>   		return NULL;
>   
> -	for (offset = NSINDEX_ALIGN * 2; offset < size;
> +	nsindex_size = ndctl_dimm_sizeof_namespace_index(dimm);
> +	if (nsindex_size == 0)
> +		return NULL;
> +
> +	for (offset = nsindex_size * 2; offset < size;
>   			offset += ndctl_dimm_sizeof_namespace_label(dimm)) {
>   		ssize_t len = min_t(ssize_t,
>   				ndctl_dimm_sizeof_namespace_label(dimm),
> @@ -204,17 +209,23 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
>   	return jarray;
>   }
>   
> -static struct json_object *dump_index_json(struct ndctl_cmd *cmd_read, ssize_t size)
> +static struct json_object *dump_index_json(struct ndctl_dimm *dimm,
> +		struct ndctl_cmd *cmd_read, ssize_t size)
>   {
>   	struct json_object *jarray = json_object_new_array();
>   	struct json_object *jindex = NULL;
>   	struct namespace_index nsindex;
> +	unsigned int nsindex_size;
>   	ssize_t offset;
>   
>   	if (!jarray)
>   		return NULL;
>   
> -	for (offset = 0; offset < NSINDEX_ALIGN * 2; offset += NSINDEX_ALIGN) {
> +	nsindex_size = ndctl_dimm_sizeof_namespace_index(dimm);
> +	if (nsindex_size == 0)
> +		return NULL;
> +
> +	for (offset = 0; offset < nsindex_size * 2; offset += nsindex_size) {
>   		ssize_t len = min_t(ssize_t, sizeof(nsindex), size - offset);
>   		struct json_object *jobj;
>   
> @@ -288,7 +299,7 @@ static struct json_object *dump_json(struct ndctl_dimm *dimm,
>   		goto err;
>   	json_object_object_add(jdimm, "dev", jobj);
>   
> -	jindex = dump_index_json(cmd_read, size);
> +	jindex = dump_index_json(dimm, cmd_read, size);
>   	if (!jindex)
>   		goto err;
>   	json_object_object_add(jdimm, "index", jindex);
> diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> index c045cbe..9e36e28 100644
> --- a/ndctl/lib/dimm.c
> +++ b/ndctl/lib/dimm.c
> @@ -256,6 +256,11 @@ static int __label_validate(struct nvdimm_data *ndd)
>   	return -EINVAL;
>   }
>   
> +NDCTL_EXPORT unsigned int ndctl_dimm_sizeof_namespace_index(struct ndctl_dimm *dimm)
> +{
> +	return sizeof_namespace_index(&dimm->ndd);
> +}
> +
>   /*
>    * If the dimm labels have not been previously validated this routine
>    * will make up a default size. Otherwise, it will pick the size based
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index 0a82616..0ce2bb9 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -290,6 +290,7 @@ global:
>   	ndctl_dimm_validate_labels;
>   	ndctl_dimm_init_labels;
>   	ndctl_dimm_sizeof_namespace_label;
> +	ndctl_dimm_sizeof_namespace_index;
>   	ndctl_mapping_get_position;
>   	ndctl_namespace_set_enforce_mode;
>   	ndctl_namespace_get_enforce_mode;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index 60e1288..9a1a799 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -335,6 +335,7 @@ int ndctl_dimm_init_labels(struct ndctl_dimm *dimm,
>   		enum ndctl_namespace_version v);
>   unsigned long ndctl_dimm_get_available_labels(struct ndctl_dimm *dimm);
>   unsigned int ndctl_dimm_sizeof_namespace_label(struct ndctl_dimm *dimm);
> +unsigned int ndctl_dimm_sizeof_namespace_index(struct ndctl_dimm *dimm);
>   unsigned int ndctl_cmd_cfg_size_get_size(struct ndctl_cmd *cfg_size);
>   ssize_t ndctl_cmd_cfg_read_get_data(struct ndctl_cmd *cfg_read, void *buf,
>   		unsigned int len, unsigned int offset);
> 
