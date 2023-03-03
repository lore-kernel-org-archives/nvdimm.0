Received: from esa11.fujitsucc.c3s2.iphmx.com (esa11.fujitsucc.c3s2.iphmx.com [216.71.156.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A861363
	for <nvdimm@lists.linux.dev>; Fri,  3 Mar 2023 02:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1677810532; x=1709346532;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3vFMWnoFfmVnx3yXuWsl1E8rD2V1nptUPeA8bMgCUuw=;
  b=HrP+pt9KruEd1ahH7mmbghvQdWndPsfMtBapf2s4Fss/DsxKrEfHeCli
   8xM5t90hVQmmu4J1LH1aaUSPoT0NZhSxaBJ/nr+8n17VTs4D4xaItZB1G
   J3mPdFfYqLiDqLORR5ZC2dB9+lvHVdP4dWsfWbtA3hliuUKgrHZPVgd/j
   RuEKdkHaOaitSC7XV+2CXVXypMgAUxqGive8CWX13KGrYko7yK46I8j/3
   jiU748NS3V/94qPFEx5q+a2eoh5hvtMsC+gkp0yLySi2OM9XdSqZxD8nl
   pM2lbq7cdYJey/DUY8ibfTk/xsn/mG5F37wnCsp88AYOICjPqc2YPgnsc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="78822134"
X-IronPort-AV: E=Sophos;i="5.98,229,1673881200"; 
   d="scan'208";a="78822134"
Received: from mail-tycjpn01lp2177.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.177])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 11:27:37 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzZgsUD5pxCwYmtN7CKqxljFObnlPYhqAEsFMJlpk1yxLMC//MtFm84X6hnncavKuxzvEaVUaCAzZ/cwiIl2CNkMhxyxMe9HHjQE+XxCbHh5HFsUZzpHJJ+2hpUkZp5aB42q4phoddx/k5+WqGfgZU86WvgUvp495KhwQ++fVfY8/Ydq9LinDDT0/AjcNGK3fax57yVg+pIyaCTtzbkqsILJ/awedDKifIoMw0ij2pRNqR50txG/5jPjvcJWr8McPYN+z+obuJyn6WITlK2CoAT1ri8klN71Tlk+ovg/Njfg9PNW3DkKD8UDpOLM/XrbOXUkyq4X6O/DO4bsMCP2bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vFMWnoFfmVnx3yXuWsl1E8rD2V1nptUPeA8bMgCUuw=;
 b=mL4YLVcE40r4EXkUQ80dkZngKNMlJ4qq1/zV1AaqjvnhP3BRu4eEMIZ/PWoX6tsrNB+iZYJQp73/nx8wwO2Diw3CYWL9p2Im1dbDh1yDztivx6yBkOS0I0K4OUtOqslndusKYPcN4l6ENbX4+48dO7b5nfRKYZQfxg22zgDww8T+cf7Usz6fhFBWg7ShtBDqZONKxOWUoBAY0o04+ACk3zS/EyWNaj0Aif6sb9rGh0zTI8XSci/oPM/02zv2cQcuc9WSnirO6ftsN3fJVMFL7nBsViwmy7dg/TX/f3fOCpFwSNQZdP/V5rOvkaXBl+oldQEjoAX+0yHuJm44eJv6tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 (2603:1096:604:1fb::14) by TYCPR01MB5646.jpnprd01.prod.outlook.com
 (2603:1096:400:a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.21; Fri, 3 Mar
 2023 02:27:34 +0000
Received: from OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::2381:b0a1:7818:ce58]) by OS3PR01MB10390.jpnprd01.prod.outlook.com
 ([fe80::2381:b0a1:7818:ce58%9]) with mapi id 15.20.6156.021; Fri, 3 Mar 2023
 02:27:34 +0000
From: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
To: Baoquan He <bhe@redhat.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "vgoyal@redhat.com" <vgoyal@redhat.com>,
	"dyoung@redhat.com" <dyoung@redhat.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"horms@verge.net.au" <horms@verge.net.au>, "k-hagio-ab@nec.com"
	<k-hagio-ab@nec.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>, "ruansy.fnst@fujitsu.com"
	<ruansy.fnst@fujitsu.com>
Subject: Re: [RFC][nvdimm][crash] pmem memmap dump support
Thread-Topic: [RFC][nvdimm][crash] pmem memmap dump support
Thread-Index: AQHZR0+Bi1lA/ErA5EK0zxLjybbH0K7kbFaAgAESzQCAAB7AgIACwugA
Date: Fri, 3 Mar 2023 02:27:34 +0000
Message-ID: <ddae42f1-749b-7665-28fa-89a3731c7b4a@fujitsu.com>
References: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
 <Y/4JxQtnmYrZgVwF@MiWiFi-R3L-srv>
 <777f338f-09cb-d9f4-fe5f-3a6f059e4b02@fujitsu.com>
 <Y/8KFYraba1Lsh5f@MiWiFi-R3L-srv>
In-Reply-To: <Y/8KFYraba1Lsh5f@MiWiFi-R3L-srv>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB10390:EE_|TYCPR01MB5646:EE_
x-ms-office365-filtering-correlation-id: fadc1c94-9181-4992-b410-08db1b8ed912
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 vHPL/4Nwx5vUvtD6oIZZtDXlBdInwcE/cg5cwszBnD6PkpfwH21B5cX5qRbQaX1D7EHqGTNJ4oU288CSsuiNcOVhHEcru4ysJciciwDuHVJqh9FWcOnI4aqPcY6J1jbXHP1cwpLFGfykNrR8/iH6p3Zc30paPprh6lFZX9alsRPJDgVz4jHbbQb8R539t6MVkr0en69U3f1u4KpVQVL5ofuXezWdN+Uvi5/97NsRDmiPOYj5yamck/H/28NOVFakRDLsEvcX638pcbVxmAQNz3PmjEtu9sm3KPWSEa6w4X/8ynPemW+BKzYC+YcEqKErOLi/tUYoydA7FwlzyVWvOvS22WZZWJKaIZS3ClNF6frb2G2pFv0lEujUsQzpnPUP69McCiVrAGF6kMMHjTUcGwvQjfhrK9UYmySqF2bPMcjk6sxEcdHC7cGfeOiNB1w90+pQhPkG/VSNgg2ZnPTfDZjg5kp33HdwtJGjyuw0HEtxx3ZDHwg4YYNkxmuaxWfDc7ie7/Wr4WH69fLIh9YgotHJVKM0ctqM/hIplytJtm9EdvhDXFQJ0SNkB4gYseYZxcA3WXOxa1UkJdC8efuIJsyHRDjMmJchPLxHBTo6d6LEN/IsoBGFzFw0BT1eYFsGB2VhV7jmeowvivCZcln97/tUefZIHo+EZcQgw9qvV2h4J6I9reR8rBD67YpS9i+sXOVnvNyTtOa6b7ewJkOihEn9JX9m92yMhWF5C6qxeEIN6mMgCmrOiTFmlivi7tjZYErlgoQ1UM0OFpvjPihZAG3lgt/wzVleC3Vfjcp2SXA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB10390.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(451199018)(1590799015)(6512007)(66476007)(186003)(26005)(122000001)(38100700002)(38070700005)(82960400001)(8936002)(8676002)(4326008)(6916009)(66946007)(41300700001)(66446008)(64756008)(91956017)(2906002)(5660300002)(76116006)(7416002)(71200400001)(478600001)(2616005)(53546011)(107886003)(66556008)(6506007)(6486002)(316002)(54906003)(85182001)(36756003)(83380400001)(86362001)(31696002)(31686004)(1580799012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bkU5dGp4NEs2RU9YdzQzSmhtMUZJUW5PajlXRElxTE03YjlvQ2IvZFkxOWtJ?=
 =?utf-8?B?VzNLekQyVnZXSCtYYnBvTWtDb01COXBTUDdQWjlIa0VmTkRPdEUxbkFtNVZD?=
 =?utf-8?B?OExSUEVlRFdlRVhzL3VZMUc1T01hMHZnSEJOUkdDMmo5cUpUckZLTllrNUlT?=
 =?utf-8?B?NVRtRWJ2VkRyWkpOaHBXVXBWNGpUaHRiYWg1NGVoeGNOOHNmNy9rM0FLdVpS?=
 =?utf-8?B?V3d0dHIxS1RFdVNXWmhia3BpeGZ0YjJYRXpPSHAybUtBN3FRRUZWTVhybGJX?=
 =?utf-8?B?Qk9ud01ETjEyd0Z1S1RsSFBBMGVTY3VqTHhXS1hFRlNGU25MTkQ1emZzRzNU?=
 =?utf-8?B?cUJ6L2pjNmF0VStRWmZOSCswajlKUTN3bUt6WmlTRnE5RnduaGk4Mk9JWGg5?=
 =?utf-8?B?bGNqMzl1NXBLZ3c5aVd1T0xhVTZYZkpJLzhqUWo5dUlhemMzaUpyWWNPVU1z?=
 =?utf-8?B?aThFYldNNG9KQ1lVb0lEOFdOR3Ewb2tMd0IydDR6aXFxd2F2UzVaQWJqOEJr?=
 =?utf-8?B?WTI5OXIrV3B0OG85djhGcjdWdFdQdE1DRWpYTEdJUkxFU25wVlNyMmkrUk93?=
 =?utf-8?B?MFYzVDFpSU5SYTFEaGtPZklGNlB4aWx1SUdrdkVocTRhd0hHYTg4N3dUcVRX?=
 =?utf-8?B?RzF0dVpwaGZ4TjBEVFNibDA5OTZTSXRLS0M3WXd2MkxmTUxZak83REJXOHM5?=
 =?utf-8?B?VXRhTGswMHJuWG16V2ErTzczYXliTko3ZkhIbVBLRks1MDFmYTZROXhnN1FN?=
 =?utf-8?B?UElLaXF5aHhqbVZ1cEVsS0hoWkdQS2ZkaWhHcUFUMXVnZTBLOW5wc1QzeDMy?=
 =?utf-8?B?ZTJ5bEdQcnJyTksrOHgxYVRMOTM5eVBnWERnemJDbTRDUThNM3pnMmIrcG5x?=
 =?utf-8?B?SzVnOTFMNHpTcWNhaUxpZjE4c2VYKzhLVExiVHBBcGFhOTBOMUxBRjZCdFZ5?=
 =?utf-8?B?RitXbnNSUXo4U1VOYWwzNExwVHorWklpWTlxcCtBaFRQOTRCYXlYSWhoMWcr?=
 =?utf-8?B?MVp1bTV0WDVUekJ0VGQ5MzdJbk81QzZPeW5peUwwTTVaMGtvdnhRbktmdHRW?=
 =?utf-8?B?aTYvWHV0RWRJakZLaytSZGVYZksrUkhnM2l1Q3NUVTQ0dmRBWi9VdXpwNUNC?=
 =?utf-8?B?SXJyaFU5QjZ5TUFJT3VnRk90RVF3RTI2bjV4a3ByQm13M3pGRlV3bEpiRDM4?=
 =?utf-8?B?Vk8rcDdkaWNkMFhud2FUYzBjV1BTa2dKSE03L01USEtyVjlNakQ1MkQ5c0lO?=
 =?utf-8?B?cU1PL3BiUTNSOGhoWGxVdDN5b3U0MCtEMlFSVUFTa2VUemsvMGJvZDFhTzNG?=
 =?utf-8?B?MFYyS2lFcExhQnJ0aFZGME9uQWIyR2JHTGNPVFdVbHBtbzZFSWJqc2dvdHVJ?=
 =?utf-8?B?NThnYmxTelI3Qk4zMHA5b2MwS0UzQk0xYlFLdzZ1cG85alJxNjl3S2d5THlM?=
 =?utf-8?B?K1hQZ2xvbkN3Y1AwbzFJS0NUb2ZCWng1czdTVVZEbVRZOVc4WkNwR1RFUCtV?=
 =?utf-8?B?OHVrc1BKNGlzWjhMRFo0L3J4MjlSZmErTVJFYjdJTWNQUUUzZllnYmFoOHNQ?=
 =?utf-8?B?WXZxZDdCWkxqakNXQm5RYkxrVHc2SlNDWnZVSjYrVGVYK1RKc0RYc0xqaG1h?=
 =?utf-8?B?Y2J5cG5FekRVRElLR2hJYURzdHB3ejV5cVlicE9DK09aWFNQTUx1dGVsQWRs?=
 =?utf-8?B?dzN5aTNnUUJ5TXNHK3FGbngvYUFWcjMxZE5pQzF0ZUlEdjl5TmhYTXRsaUtC?=
 =?utf-8?B?NitGVjFZK3hoV0NqU1pvRHF5Q0R5K1pyZ3dVTFArNmJmZnZhLzZ2QlZlcGxJ?=
 =?utf-8?B?bTg1Z2hpQU1uVE5EbXc1Q08wZHZNL1FTNkowc0tOTGJvS1gyUy9SVk05NHRo?=
 =?utf-8?B?Z2pyK2RFRkdzV2ZaYkJQR3dXYVpwZEx0dW5IZmRpM0tudkJ3RUJybkN6ZjFQ?=
 =?utf-8?B?ZTgyWWxRbVlJMWsxUGtVa1lJbS83Vm0vb3lrSlZmUlVYdEI0K1U5TlgvOUhT?=
 =?utf-8?B?WlRSNFBOT2Q4eWRvTkZUWE9WdmZ5UG9PSlBnK1dyUkQ3aE1GcVAxZ1dHVm1n?=
 =?utf-8?B?TVNiMWdaN1pvZ3VQQXNGSkV5SktQdURVZzNSY3JhRCtnZmpubXlLMHU5amFw?=
 =?utf-8?B?UzVJWHV0OHVaS1libnZDd08rVS9wTE5qSlJPeTRnSGlXcHpWVzc3SjhBN0Jm?=
 =?utf-8?B?UlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8DE1D9752C20D42AFD2AFEEB7D09D76@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	=?utf-8?B?UkYrSHdPbHppd1BYeUl6REUyVkZNSGg0TkxiNmJieGVBYTUwcnRqdHdUcXhv?=
 =?utf-8?B?UHJZU2MzM2ZxNDJHaUp2ZFcvdEYrSTMweHlVNU5TOEdNY2pMQ1FqUmNPL0pn?=
 =?utf-8?B?b0phaVpiaDVGanFLKzArK2djTmFsaHoySFVaeHZ6ZTZoRVo0ZE1oUkdWOG9n?=
 =?utf-8?B?OXJTT2JrNU1na01hK1ZUUEpvNWxuZWM0d1hoUGdNTXlWTWZwVjJMcS9Gd09P?=
 =?utf-8?B?bGlDd1lVL01KNGpad3k0a3BRT0NYUGFTbGJUaHhqL1lOMlpRRmJwYjdYU1dQ?=
 =?utf-8?B?WCttVkVJejI1S3Z4VzdFYUk3VVVOOHhMb2t5RkJubGNzejhiVHFmRjR5S1ox?=
 =?utf-8?B?N2JadWp0amloU0ZGVEp1aG9NdVNLdk53eGtUUlRxNnJpNnFRbzFqQUtqRW5r?=
 =?utf-8?B?eVRoT2RFWUovUEh1R0ZpMnQ3QUl0eU5peGZONjV3cCtyTW82VG9TNUt2ejdN?=
 =?utf-8?B?QlROMFdCUXJ6WjFYWG9wbE1qaTIrWkg3bjVqRXp5Y2Nad09DbGg0MGF2cUw5?=
 =?utf-8?B?d2xzcythYnFtdnpKTllPQTVuUzQ2cHFqZWpZOVFhbTRCYWlGSWJWejltQ0Nh?=
 =?utf-8?B?VWJWQ09qRGt1Q3lRWmNVZ2o2UUtBY2RXSHhaeDRxNFBXbDdUa3dGeTAxcmta?=
 =?utf-8?B?VFhVLzFLZWIvVjJ5NlNHdG1TN3dhYkNGVWtyUlUrTXBkdU1NZHNyTCs5bEdU?=
 =?utf-8?B?SSt3emFNanZLUG1zemZkMmhFMnZSeUg1STRtYzdWMUhjZUI2RmFVT1hnb1BU?=
 =?utf-8?B?UHczdXZ6NGNMTzUwc3YrWStDTnhPQy9qbGlYYWFPeERyWGpDb2RRaDhKTHpS?=
 =?utf-8?B?bEZXVGFnWlU1OWplTUpOZFV5eDlaWnd3empUZDB5Ui9xMC9tVVNHZFhCZGMw?=
 =?utf-8?B?QkNTa1VxYlJCN0YvZG5wOW1NVWIrVlEweWY0UFoyWjRJSWlka1BZWGZwN0hY?=
 =?utf-8?B?NkFXSDMxQWR6cUVpSWQxS29PSXpqVTVrM1dFamhQVWJ4VFBGc0ZaYmI4YkJ6?=
 =?utf-8?B?UE1pbmZVampzdi9hR2cyVlZONWdRWmhGdldRamNoYkVxNzBLVDBVUm5nZDUx?=
 =?utf-8?B?N2NsdjFack1SbjhRZzkrWFN5UG5FQXpPcEZDRXRLVFVvU2E0VjFQeHFqWUoy?=
 =?utf-8?B?d1ZTNVdoSFN0aHQ1alBlcTBVb1ZWK3A3OTBOZm91YWd1RG05VHNjWEpmbXFD?=
 =?utf-8?B?dFVRTjl3cDNENzdReVBkTjRQaXFGYWxZUktXWWo4M2l6akNNNk1VQnZRY2p1?=
 =?utf-8?B?ZmFQTmRHTm9mLzcxclJSU0FHbk9qRlVBUytpZ3lPNnFpY1lPWWRVb2JNbEsy?=
 =?utf-8?B?MDZaMDIxbnlaM1VSZUZhL1dYanMvYjdBeFgvMHZQOE1lSWkySDdPL3JBZW9s?=
 =?utf-8?B?T29vME11azliV0E9PQ==?=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB10390.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fadc1c94-9181-4992-b410-08db1b8ed912
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 02:27:34.3932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D0QwUIkObFE+FRAaNE7cJwGpGgTSXtJipqyBwD1j1pluhaB8LN0ZmCkloi8s1ibBro5UWnl5H37ZjJQXTR/Ong==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB5646

DQoNCk9uIDAxLzAzLzIwMjMgMTY6MTcsIEJhb3F1YW4gSGUgd3JvdGU6DQo+IE9uIDAzLzAxLzIz
IGF0IDA2OjI3YW0sIGxpemhpamlhbkBmdWppdHN1LmNvbSB3cm90ZToNCj4gLi4uLi4uDQo+PiBI
aSBCYW9xdWFuDQo+Pg0KPj4gR3JlYXRseSBhcHByZWNpYXRlIHlvdXIgZmVlZGJhY2suDQo+Pg0K
Pj4NCj4+PiAxKSBJbiBrZXJuZWwgc2lkZSwgZXhwb3J0IGluZm8gb2YgcG1lbSBtZXRhIGRhdGE7
DQo+Pj4gMikgaW4gbWFrZWR1bXBmaWxlIHNpemUsIGFkZCBhbiBvcHRpb24gdG8gc3BlY2lmeSBp
ZiB3ZSB3YW50IHRvIGR1bXANCj4+PiAgICAgIHBtZW0gbWV0YSBkYXRhOyBBbiBvcHRpb24gb3Ig
aW4gZHVtcCBsZXZlbD8NCj4+DQo+PiBZZXMsIEknbSB3b3JraW5nIG9uIHRoZXNlIDIgc3RlcC4N
Cj4+DQo+Pj4gMykgSW4gZ2x1ZSBzY3JpcHQsIGRldGVjdCBhbmQgd2FybiBpZiBwbWVtIGRhdGEg
aXMgaW4gcG1lbSBhbmQgd2FudGVkLA0KPj4+ICAgICAgYW5kIGR1bXAgdGFyZ2V0IGlzIHRoZSBz
YW1lIHBtZW0uDQo+Pj4NCj4+DQo+PiBUaGUgJ2dsdWUgc2NyaXB0JyBtZWFucyB0aGUgc2NpcnB0
IGxpa2UgJy91c3IvYmluL2tkdW1wLnNoJyBpbiAybmQga2VybmVsPyBUaGF0IHdvdWxkIGJlIGFu
IG9wdGlvbiwNCj4+IFNoYWxsIHdlIGFib3J0IHRoaXMgZHVtcCBpZiAicG1lbSBkYXRhIGlzIGlu
IHBtZW0gYW5kIHdhbnRlZCwgYW5kIGR1bXAgdGFyZ2V0IGlzIHRoZSBzYW1lIHBtZW0iID8NCj4g
DQo+IEd1ZXNzIHlvdSBhcmUgc2F5aW5nIHNjcmlwdHMgaW4gUkhFTC9jZW50b3MvZmVkb3JhLCBh
bmQgeWVzIGlmIEkgZ3Vlc3MNCj4gcmlnaC4gT3RoZXIgZGlzdHJvcyBjb3VsZCBoYXZlIGRpZmZl
cmVudCBzY3JpcHRzLiBGb3Iga2R1bXAsIHdlIG5lZWQNCj4gbG9hZCBrZHVtcCBrZXJuZWwvaW5p
dHJhbWZzIGluIGFkdmFuY2UsIHRoZW4gd2FpdCB0byBjYXB0dXJlIGFueSBjcmFzaC4NCj4gV2hl
biB3ZSBsb2FkLCB3ZSBjYW4gZGV0ZWN0IGFuZCBjaGVjayB3aGV0aGVyIHRoZSBlbnZpcm9ubWVu
dCBhbmQNCj4gc2V0dXAgaXMgZXhwZWN0ZWQuIElmIG5vdCwgd2UgY2FuIHdhcm4gb3IgZXJyb3Ig
b3V0IG1lc3NhZ2UgdG8gdXNlcnMuDQoNCg0KSUlVQywgdGFrZSBmZWRvcmEgZm9yIGV4YW1wbGUs
DQpUMTogaW4gMXN0IGtlcm5lbCwga2R1bXAuc2VydmljZSgvdXNyL2Jpbi9rZHVtcGN0bCkgd2ls
bCBkbyBhIHNhbml0eSBjaGVjayBiZWZvcmUgbG9hZGluZyBrZXJuZWwgYW5kIGluaXRyYW1mcy4N
CiAgICAgSW4gdGhpcyBtb21lbnQsIGFzIHlvdSBzYWlkICJ3ZSBjYW4gZGV0ZWN0IGFuZCBjaGVj
ayB3aGV0aGVyIHRoZSBlbnZpcm9ubWVudCBhbmQgc2V0dXAgaXMgZXhwZWN0ZWQuIElmIG5vdCwN
CiAgICAgd2UgY2FuIHdhcm4gb3IgZXJyb3Igb3V0IG1lc3NhZ2UgdG8gdXNlcnMuIg0KICAgICBJ
IHRoaW5rIHdlIHNob3VsZCBhYm9ydCB0aGUga2R1bXAgc2VydmljZSBpZiAicG1lbSBkYXRhIGlz
IGluIHBtZW0gYW5kIHdhbnRlZCwgYW5kIGR1bXAgdGFyZ2V0IGlzIHRoZSBzYW1lIHBtZW0iLg0K
ICAgICBGb3IgT1MgYWRtaW5pc3RyYXRvcnMsIHRoZXkgY291bGQgZWl0aGVyIGNoYW5nZSB0aGUg
ZHVtcCB0YXJnZXQgb3IgZGlzYWJsZSB0aGUgcG1lbSBtZXRhZGFkYXRhIGR1bXAgdG8gbWFrZQ0K
ICAgICBrZHVtcC5zZXJ2aWNlIHdvcmsgYWdhaW4uDQoNCkJ1dCBrZHVtcC5zZXJ2aWNlIGlzIGRp
c3Ryb3MgaW5kZXBlbmRlbnQsIHNvbWUgT1MgYWRtaW5pc3RyYXRvcnMgd2lsbCB1c2UgYGtleGVj
YCBjb21tYW5kIGRpcmVjdGx5IGluc3RlYWQgb2Ygc2VydmljZS9zY3JpcHQgaGVscGVycy4NCg0K
DQo+IFdlIGRvbid0IG5lZWQgdG8gZG8gdGhlIGNoZWNraW5nIHVudGlsIGNyYXNoIGlzIHRyaWdn
ZXJlZCwgdGhlbiBkZWNpZGUNCj4gdG8gYWJvcnQgdGhlIGR1bXAgb3Igbm90Lg0KDQpUMjogaW4g
Mm5kIGtlcm5lbCwgc2luY2UgMXN0IGtlcm5lbCdzIGdsdWUgc2NyaXB0cyB2YXJ5IGJ5IGRpc3Ry
aWJ1dGlvbiwgd2UgaGF2ZSB0byBkbyB0aGUgc2FuaXR5IGNoZWNrIGFnYWluIHRvIGRlY2lkZQ0K
dG8gYWJvcnQgdGhlIGR1bXAgb3Igbm90Lg0KDQoNCg0KPiANCj4+PiBEb2VzIHRoaXMgd29yayBm
b3IgeW91Pw0KPj4+DQo+Pj4gTm90IHN1cmUgaWYgYWJvdmUgaXRlbXMgYXJlIGFsbCBkby1hYmxl
LiBBcyBmb3IgcGFya2luZyBwbWVtIGRldmljZQ0KPj4+IHRpbGwgaW4ga2R1bXAga2VybmVsLCBJ
IGJlbGlldmUgaW50ZWwgcG1lbSBleHBlcnQga25vdyBob3cgdG8gYWNoaWV2ZQ0KPj4+IHRoYXQu
IElmIHRoZXJlJ3Mgbm8gd2F5IHRvIHBhcmsgcG1lbSBkdXJpbmcga2R1bXAganVtcGluZywgY2Fz
ZSBEKSBpcw0KPj4+IGRheWRyZWFtLg0KPj4NCj4+IFdoYXQncyAia2R1bXAganVtcGluZyIgdGlt
aW5nIGhlcmUgPw0KPj4gQS4gMXN0IGtlcm5lbCBjcmFzaGVkIGFuZCBqdW1waW5nIHRvIDJuZCBr
ZXJuZWwgb3INCj4+IEIuIDJuZC9rZHVtcCBrZXJuZWwgZG8gdGhlIGR1bXAgb3BlcmF0aW9uLg0K
Pj4NCj4+IEluIG15IHVuZGVyc3RhbmRpbmcsIGR1bXBpbmcgYXBwbGljYXRpb24obWFrZWR1bXBm
aWxlKSBpbiBrZHVtcCBrZXJuZWwgd2lsbCBkbyB0aGUgZHVtcCBvcGVyYXRpb24NCj4+IGFmdGVy
IG1vZHVsZXMgbG9hZGVkLiBEb2VzICJwYXJraW5nIHBtZW0iIG1lYW4gdG8gcG9zdHBvbmUgcG1l
bSBtb2R1bGVzIGxvYWRpbmcgdW50aWwgZHVtcA0KPj4gb3BlcmF0aW9uIGZpbmlzaGVkID8gaWYg
c28sIGkgdGhpbmsgaXQgaGFzIHRoZSBzYW1lIGVmZmVjdCB3aXRoIGRpc2FibGluZyBwbWVtIGRl
dmljZSBpbiBrZHVtcCBrZXJuZWwuDQo+IA0KPiBJIHVzZWQgcGFya2luZyB3aGljaCBzaG91bGQg
YmUgd3JvbmcuIFdoZW4gY3Jhc2ggaGFwcGVuZWQsIHdlIGN1cnJlbnRseQ0KPiBvbmx5IHNodXRk
b3duIHVucmVsYXRlZCBDUFUgYW5kIGludGVydXB0IGNvbnRyb2xsZXIsIGJ1dCBrZWVwIG90aGVy
DQo+IGRldmljZXMgb24tZmxpZ2h0LiBUaGlzIGlzIHdoeSB3ZSBjYW4gcHJlc2VydmUgdGhlIGNv
bnRlbnQgb2YgY3Jhc2gtZWQNCj4ga2VybmVsJ3MgbWVtb3J5LiBGb3Igbm9ybWFsIG1lbW9yeSBk
ZXZpY2UsIHdlIHJlc2VydmUgc21hbGwgcGFydCBhcw0KPiBjcmFzaGtlcm5lbCB0byBydW4ga2R1
bXAga2VybmVsIGFuZCBkdW1waW5nLCBrZWVwIHRoZSAxc3Qga2VybmVsJ3MNCj4gbWVtb3J5IHVu
dG91Y2hlZC4gRm9yIHBtZW0sIHdlIG1heSBuZWVkIHRvIGRvIHNvbWV0aGluZyBzaW1pbGFyIHRv
IGtlZXANCj4gaXRzIGNvbnRlbnQgdW50b3VjaGVkLiBJIGFtIG5vdCBzdXJlIGlmIGRpc2FibGlu
ZyBwbWVtIGRldmljZSBpcyB0aGUNCj4gdGhpbmcgd2UgbmVlZCBkbyBpbiBrZHVtcCBrZXJuZWws
IHdoYXQgd2Ugd2FudCBpcw0KPiAxKSBub3Qgc2h1dGRvd24gcG1lbSBpbiAxc3Qga2VybmVsIHdo
ZW4gY3Jhc2gtZWQNCj4gMikgZG8gbm90IHJlLWluaXRpYWxpemUgcG1lbSwgYXQgbGVhc3QgZG8g
bm90IHJlbW92ZSBpdHMgY29udGVudA0KPiANCj4gMSkgaGFzIGJlZW4gdGhlcmUgd2l0aCB0aGUg
Y3VycmVudCBoYW5kbGluZy4gDQoNCkkgdGhpbmsgc28uDQoNCg0KV2UgbmVlZCBkbyBzb21ldGhp
bmcgdG8NCj4gZ3VhcmFudGVlIDIpPyBJIGRvbid0IGtub3cgcG1lbSB3ZWxsLCBqdXN0IHBlcnNv
bmFsIHRob3VnaHQuDQoNCnRoYW5rcyBmb3IgeW91ciBpZGVhLCBpIHdpbGwgdGFrZSBhIGRlZXBl
ciBsb29rLg0KDQoNClRoYW5rcw0KWmhpamlhbg0KDQoNCj4g
