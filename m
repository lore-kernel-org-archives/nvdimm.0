Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F43168
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 01:17:19 +0000 (UTC)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GQG7J63jXz1CJKh
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 08:52:44 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 08:58:23 +0800
Received: from [127.0.0.1] (10.174.177.249) by dggema765-chm.china.huawei.com
 (10.1.198.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 15
 Jul 2021 08:58:22 +0800
Subject: Re: [ndctl PATCH v2 2/2] namespace: Close fd before return in
 do_xaction_namespace()
To: <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, linfeilong <linfeilong@huawei.com>,
	<lixiaokeng@huawei.com>, Alison Schofield <alison.schofield@intel.com>
References: <c3c08075-4815-8e84-2ba6-64644e72abee@huawei.com>
 <a10193c0-e56b-8bf1-7ce4-d0c0f7bdc35b@huawei.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <6060dada-9ad0-c6bc-0c2a-89ced6414120@huawei.com>
Date: Thu, 15 Jul 2021 08:58:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a10193c0-e56b-8bf1-7ce4-d0c0f7bdc35b@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected

friendly ping...

On 2021/7/6 12:33, Zhiqiang Liu wrote:
> Recently, we use Coverity to analysis the ndctl package,
> one issue in do_xaction_namespace() is reported as follows,
> 	CID 11690564: (RESOURCE_LEAK)
> 	2058. leaked_storage: Variable "ri_ctx" going out of scope
> 	      leaks the storage "ri_ctx.f_out" points to.
>
> In do_xaction_namespace(), ri_ctx.f_out should be closed after
> being opened. This prevents a potential file descriptor leak
> in do_xaction_namespace().
>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
> v1->v2: add coverity report info as suggested by Alison
>
>  ndctl/namespace.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 21089d7..55364ac 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -2141,7 +2141,7 @@ static int do_xaction_namespace(const char *namespace,
>  				util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
>  			if (rc >= 0)
>  				(*processed)++;
> -			return rc;
> +			goto out;
>  		}
>  	}
>
> @@ -2152,11 +2152,11 @@ static int do_xaction_namespace(const char *namespace,
>  		rc = file_write_infoblock(param.outfile);
>  		if (rc >= 0)
>  			(*processed)++;
> -		return rc;
> +		goto out;
>  	}
>
>  	if (!namespace && action != ACTION_CREATE)
> -		return rc;
> +		goto out;
>
>  	if (verbose)
>  		ndctl_set_log_priority(ctx, LOG_DEBUG);
> @@ -2212,7 +2212,7 @@ static int do_xaction_namespace(const char *namespace,
>  						saved_rc = rc;
>  						continue;
>  				}
> -				return rc;
> +				goto out;
>  			}
>  			ndctl_namespace_foreach_safe(region, ndns, _n) {
>  				ndns_name = ndctl_namespace_get_devname(ndns);
> @@ -2259,7 +2259,7 @@ static int do_xaction_namespace(const char *namespace,
>  					rc = namespace_reconfig(region, ndns);
>  					if (rc == 0)
>  						*processed = 1;
> -					return rc;
> +					goto out;
>  				case ACTION_READ_INFOBLOCK:
>  					rc = namespace_rw_infoblock(ndns, &ri_ctx, READ);
>  					if (rc == 0)
> @@ -2281,9 +2281,6 @@ static int do_xaction_namespace(const char *namespace,
>  	if (ri_ctx.jblocks)
>  		util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
>
> -	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
> -		fclose(ri_ctx.f_out);
> -
>  	if (action == ACTION_CREATE && rc == -EAGAIN) {
>  		/*
>  		 * Namespace creation searched through all candidate
> @@ -2301,6 +2298,10 @@ static int do_xaction_namespace(const char *namespace,
>  	if (saved_rc)
>  		rc = saved_rc;
>
> +out:
> +	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
> +		fclose(ri_ctx.f_out);
> +
>  	return rc;
>  }
>

