Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F9B19B
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 04:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10878"; a="117321718"
X-IronPort-AV: E=Sophos;i="6.03,262,1694703600"; 
   d="scan'208";a="117321718"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 13:33:46 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 393C9D64A0
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 13:33:44 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 6B068BF3E4
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 13:33:43 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 0AB202007473B
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 13:33:43 +0900 (JST)
Received: from [10.167.215.54] (unknown [10.167.215.54])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 66D2F1A0071;
	Mon, 30 Oct 2023 12:33:42 +0800 (CST)
Message-ID: <c460ae5c-1685-9e41-5531-8b8016645f70@fujitsu.com>
Date: Mon, 30 Oct 2023 12:33:40 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
To: Dave Jiang <dave.jiang@intel.com>, vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, caoqq@fujitsu.com
References: <169525064907.3085225.2583864429793298106.stgit@djiang5-mobl3>
 <59e51baa-cd6f-7045-178f-c327a693f803@fujitsu.com>
 <7a01a5aa-678d-42ff-a877-8aaa8feb3fbd@intel.com>
From: Xiao Yang <yangx.jy@fujitsu.com>
In-Reply-To: <7a01a5aa-678d-42ff-a877-8aaa8feb3fbd@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27966.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27966.004
X-TMASE-Result: 10--11.281800-10.000000
X-TMASE-MatchedRID: GnNqJBi8oAePvrMjLFD6eJTQgFTHgkhZ9mojSc/N3QeqvcIF1TcLYJCl
	VuR6WzhZKaK0jzrN6aA3pwoeDAoHmTjBjEWktJsNSHCU59h5KrHnrllatbeJEFc/CedjlcvkRtU
	L4XifTnux3dLgEL2IPssSTjDnjl5dSSOWVJeuO1CDGx/OQ1GV8t8dWDYdvqmpDrBAjvbPhh50HS
	e131POnjsAVzN+Ov/s4gK2WjROBAcj+ghXVyPWxlLy7/vMxlOk8RlKhbtY40nR/8G8FzL1WQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

On 2023/10/14 6:38, Dave Jiang wrote:
> 
> On 10/9/23 03:52, Xiao Yang wrote:
>> On 2023/9/21 6:57, Dave Jiang wrote:
>>> +        if (daxctl_memory_online_no_movable(mem)) {
>>> +            log_err(&rl, "%s: memory unmovable for %s\n",
>>> +                    devname,
>>> +                    daxctl_dev_get_devname(dev));
>>> +            return -EPERM;
>>> +        }
>> Hi Dave,
>>
>> It seems wrong to check if memory is unmovable by the return number of daxctl_memory_online_no_movable(mem) here. IIRC, the return number of daxctl_memory_online_no_movable(mem)/daxctl_memory_op(MEM_GET_ZONE) indicates how many memory blocks have the same memory zone. So I think you should check mem->zone and MEM_ZONE_NORMAL as daxctl_memory_is_movable() did.
> Do you mean:
> rc = daxctl_memory_online_no_movable(mem);
> if (rc < 0)
> 	return rc;
> if (rc > 0) {
> 	log_err(&rl, "%s memory unmovable for %s\n' ...);
> 	return -EPERM;
> }
> 
Hi Dave,

Sorry for the late reply.

Is it necessary to try to online the memory region to the 
MEM_ZONE_NORMAL by daxctl_memory_online_no_movable(mem)? If you just 
want to check if the onlined memory region is in the MEM_ZONE_NORMAL, 
the following code seems better:
     mem->zone = 0;
     rc = daxctl_memory_op(mem, MEM_GET_ZONE);
     if (rc < 0)
         return rc;
     if (mem->zone == MEM_ZONE_NORMAL) {
         log_err(&rl, "%s memory unmovable for %s\n' ...);
	return -EPERM;
     }

Best Regards,
Xiao Yang
