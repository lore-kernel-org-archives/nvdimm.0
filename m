Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD79182A1
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 09:56:56 +0000 (UTC)
Received: from [134.238.52.102] (helo=[10.8.4.2])
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1qJ9ng-00BpLQ-OI; Tue, 11 Jul 2023 10:36:53 +0100
Message-ID: <a066097a-b02e-eee0-c57a-27dd7fbe6989@codethink.co.uk>
Date: Tue, 11 Jul 2023 10:36:49 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] ACPI: NFIT: limit string attribute write
Content-Language: en-GB
To: nvdimm@lists.linux.dev
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
References: <20230711092244.22527-1-ben.dooks@codethink.co.uk>
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <20230711092244.22527-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/07/2023 10:22, Ben Dooks wrote:
> If we're writing what could be an arbitrary sized string into an attribute
> we should probably use sysfs_emit() just to be safe. Most of the other
> attriubtes are some sort of integer so unlikely to be an issue so not
> altered at this time.
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
> v2:
>    - use sysfs_emit() instead of snprintf.
> ---
>   drivers/acpi/nfit/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 9213b426b125..d7e9d9cd16d2 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1579,7 +1579,7 @@ static ssize_t id_show(struct device *dev,
>   {
>   	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
>   
> -	return sprintf(buf, "%s\n", nfit_mem->id);
> +	return snprintf(buf, PAGE_SIZE, "%s\n", nfit_mem->id);
>   }
>   static DEVICE_ATTR_RO(id);
>   

whoops, forgot to add before hitting ammend...

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

